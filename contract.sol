// not production grade
// SPDX-License-Identifier: MIT;
pragma solidity >0.7.0 <0.9.0;

contract cryptobike{

address owner;

constructor() {
owner = msg.sender;
}

struct renter {
    string last_name;
    string first_name;
    address payable wallet;
    bool canrent;
    bool active;
    uint balance;
    uint due;
    uint start;
    uint end;
}

mapping (address => renter) public renters;

function addrenter(string memory last_name,string memory first_name,address payable wallet,bool canrent,bool active,uint balance,uint due,uint start,uint end) public {
renters[wallet]=renter(last_name,first_name, wallet,canrent,active,balance,due,start,end);
}

function checkout(address wallet) public {
renters[wallet].active = true;
renters[wallet].start=block.timestamp;
renters[wallet].canrent = false;
}

function checkin(address wallet) public {
renters[wallet].active = false;
//renters[wallet].canrent = true;
renters[wallet].end =block.timestamp;
//renters[wallet].due = 0;
setdue(wallet);
}
//get total duration of bike use
function rentertimespan (uint start,uint end) internal pure returns(uint){
return end - start;
}

function getTotalDuration(address wallet) public view returns (uint) {
uint timespan= rentertimespan(renters[wallet].start, renters[wallet].end);
uint timespaninMinutes = timespan / 60;
return timespaninMinutes;
}
//balance of contract
function balanceof() public view returns (uint){
return address(this).balance;
}
//balance of renter
function balanceofrenter(address wallet) public view returns (uint) {
return renters[wallet].balance;
}
//set due amount
function setdue(address wallet) internal{
uint timespaminminutes = getTotalDuration(wallet);
//everry 5 mn cost 0.05 bnb
uint timespamover5 = timespaminminutes/5;
renters[wallet].due= timespamover5 * 5000000000000000;
}

//deposit money
function deposit(address wallet) public payable{
    renters[wallet].balance+= msg.value;
}
//make payment
function withdraw(address wallet) public payable{
    renters[wallet].balance-= msg.value;
    renters[wallet].canrent = true;
    renters[wallet].due = 0;
    renters[wallet].start = 0;
    renters[wallet].end= 0;
}
function canrentbike(address wallet) public view returns (bool){
    return renters[wallet].canrent;
}


}
