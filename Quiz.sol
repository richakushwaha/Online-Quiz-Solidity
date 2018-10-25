pragma solidity ^0.4.0;
contract QuizManager
{
    address manager;
    bytes32 name;
    uint8 n = 0;
    uint8 qs = 4;
    string q1 = '';
    string q2 = '';
    string q3 = '';
    string q4 = '';
    string a1 = '';
    string a2 = '';
    string a3 = '';
    string a4 = '';
    uint8[] pFee; //instead maintain a mapping of address and players for security !!
    uint8 tFee = 0;
    struct player_ans {
        string ans1;
        string ans2;
        string ans3;
        string ans4;
    }
    player_ans[] ans_array;
    bool QA_added = false;
    modifier initialize_game_setting {
        require(QA_added);
        _;
    }
    modifier game_started {
        require(QA_added);
        _;
    }
    constructor (bytes32 _name) public
    {
        manager = msg.sender;
        name = _name;
    }
    function initialize_game_by_manager(uint8 _n, string _q1, string _q2, string _q3, string _q4, string _a1, string _a2, string _a3, string _a4) public
    {
        // add onlyOwner modifier
        n = _n;
        q1 = _q1;
        q2 = _q2;
        q3 = _q3;
        q4 = _q4;
        a1 = _a1;
        a2 = _a2;
        a3 = _a3;
        a4 = _a4;
    }
    function initialize_game_by_players(uint8 _pFee_player) public
    {
        // add player modifier
        pFee.push(_pFee_player);
    }
    
}
