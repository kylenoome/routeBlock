// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ETHDaddy is ERC721 {
  // to be used as counter cache
  uint256 public maxSupply;
  uint256 public totalSupply;
  address public owner;

  // TODO:
  // 1: [x] List domains
  // 2: [x] Buy domains
  // 3: [x] Get payed fees

  struct Domain {
    string name;
    uint256 cost; // Ether cost expressed in Wei
    bool isOwned;
  }

  mapping(uint256 => Domain) domains;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  constructor(
    string memory _name,
    string memory _symbol
  ) ERC721(_name, _symbol) {
    owner = msg.sender;
  }

  function list(string memory _name, uint256 _cost) public onlyOwner {
    // [x] Model domain => struct
    // [x] Save domain
    // [x] Update total domain count
    maxSupply++;
    domains[maxSupply] = Domain(_name, _cost, false);
  }

  function mint(uint256 _id) public payable {
    require(_id != 0);
    require(_id <= maxSupply); // make sure valid ID
    require(domains[_id].isOwned == false); // make sure domain is not owned
    require(msg.value >= domains[_id].cost); // make sure eth is correct amount

    domains[_id].isOwned = true;
    totalSupply++;

    _safeMint(msg.sender, _id);
  }

  function getDomain(uint256 _id) public view returns (Domain memory) {
    return domains[_id];
  }

  function getBalance() public view returns (uint256) {
    return address(this).balance;
  }

  function withdraw() public onlyOwner {
    (bool success, ) = owner.call{ value: address(this).balance }("");
    require(success);
  }
}
