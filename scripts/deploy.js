const hre = require("hardhat");

const tokens = (n) => {
  return ethers.utils.parseUnits(n.toString(), "ether");
};

async function main() {
  // Setup accounts & variables
  const [deployer] = await ethers.getSigners();
  const NAME = "ETH Daddy";
  const SYMBOL = "ETHD";

  // Deploy contract
  const ETHDaddy = await ethers.getContractFactory("ETHDaddy");
  const ethDaddy = await ETHDaddy.deploy(NAME, SYMBOL);
  await ethDaddy.deployed();

  console.log(`Deployed Domain Contract at: ${ethDaddy.address}\n`);

  // List 6 domains
  const names = [
    "kyle.eth",
    "noome.eth",
    "dre.eth",
    "cobalt.eth",
    "oxygen.eth",
    "carbon.eth",
  ];
  const costs = [
    tokens(10),
    tokens(25),
    tokens(15),
    tokens(2.5),
    tokens(3),
    tokens(1),
  ];

  for (var i = 0; i < 6; i++) {
    const transaction = await ethDaddy
      .connect(deployer)
      .list(names[i], costs[i]);
    await transaction.wait();

    console.log(`Listed Domain ${i + 1}: ${names[i]}`);
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
