pragma solidity ^0.8.0;
contract TreasureGame {
    address[] public player;

    // if the value is less than 100, it represent diamend card, there are 17 diamend card
    // else if the value is less then 999, it represent crisis card, there are 5 types of crisis card and 3 card for each type of crisis card
    // else it represent the holy craft card, there are 5 holy craft card
    uint[] private card;
    uint[] private discardedCard;

    mapping (address => uint) commitInfo;
    mapping (address => uint) commitment;
    mapping (address => uint) revelation;
    mapping (address => uint) points;
    mapping (address => uint) HolyCraftPoint;

    // used for player when they login in as player
    mapping (address => bool) logined;
    mapping (address => bool) committed;
    mapping (address => bool) revealed;

    mapping (uint => uint) HolyCraft;

    // store the winner (The amount of winner might be 1 to 3)
    uint[3] winner;
    uint dimendPointsInFields;
    uint holyCraftNumInFields;
    uint round;
    bool done;
    bool isAbleToBuyNFT;

    event playerRegistered(address player);
    event printMessage(string mes);
    event gameBegins(address[] player);

    constructor() public {

        // intialize all cards
        for (uint i = 1; i < 18; i++) {
            card.push(i);
        }
        for (uint i = 1; i < 6; i++) {
            for (uint j = 0; j < 3; j++) {
                card.push(i * 100);
            }
        }

        // initialize holy crafts
        HolyCraft[0] = 5;
        HolyCraft[1] = 7;
        HolyCraft[2] = 8;
        HolyCraft[3] = 10;
        HolyCraft[4] = 12;
    }

    function register() public {
        if (!logined[msg.sender]) {
            if (player.length <= 8) {
                logined[msg.sender] = true;
                player.push(msg.sender);
                emit playerRegistered(msg.sender);
            } else {
                emit printMessage("The game is full, please join another game!");
            }

        } else {
            emit printMessage("You have registered before!");
        }
        
    }

    function gameBegin() public {
        if (player.length >= 3) {
            emit gameBegins(player);
            roundPlay(round);
        } else {
            emit printMessage("At least 3 people is required to start this game!");
        }
    }

    function roundPlay(uint roundNum) private {
        if (roundNum >= 5) {
            gameOver();
        } else {
            card.push(1000 + round);
        }
    }

    function gameOver() private {

    }

    function commit (uint _commit) public {
        if (!logined[msg.sender]) {
            emit printMessage("You need to register first!");
        } else if (committed[msg.sender]) {
            emit printMessage("You have already commited!");
        } else {
            commitment[msg.sender] = _commit;
            committed[msg.sender] = true;
        }
    }

    function reveal (uint _reveal) public {
        if (!logined[msg.sender]) {
            emit printMessage("You need to register first!");
        } else if (revealed[msg.sender]) {
            emit printMessage("You have already revealed!");
        }
    }

    // input a number and this function will return its hash value. Use it to generate the commitment value
    function hash(uint _num) public returns(uint) {
        uint RandomInfo = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, msg.sender)));
        commitInfo[msg.sender] = RandomInfo;
        return uint(keccak256(abi.encodePacked(RandomInfo, _num)));
    }
}