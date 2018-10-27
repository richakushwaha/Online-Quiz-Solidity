pragma solidity ^0.4.0;

contract Quiz
{
    address quizMaster;
    bytes32 name;
    
    //number of players that can participate
    uint8 n = 0;
    uint8 totalQuestions = 4;
    uint8 questionRevealed = 0;
    uint8 participantsRegistered = 0;
    uint8 participationFee = 0;
    uint8 tFee = 0;

    struct Player
    {
        address playerId;

        string[] answers ;
        //account of a player
        uint8 account;
        //total reward gained in the quiz
        uint8 reward;
    }
    
    string[] questions;
    string[] answers;
    Player[] participants;
    mapping (address => uint) participantNumber ;
    
    modifier checkIfPlayersNotMoreThanN()
    {
        require ( n == participantsRegistered , "No more players can participate");
        _;
    }
    modifier notQuizMaster()
    {
        require (msg.sender != quizMaster , "Quiz master cannot be a player");
        _;
    }
    modifier notPlayer()
    {
        // bytes memory tempEmptyStringTest = bytes(emptyStringTest);
        require (participantNumber[msg.sender] > 0 , "Quiz has already initiatized");
        _;
    }
    modifier notAlreadyRegistered()
    {
        require (participantNumber[msg.sender] > 0 , "You are already registered in the quiz");
        _;
    }
    modifier checkAccountBalance(uint8 initialAccount)
    {
        require (initialAccount >= participationFee, "You don't have enough balance in your account to participate");
        _;
    }
    
    modifier onlyQuizMaster()
    {
        require(msg.sender == quizMaster, "Only quiz master can end or start the quiz");
        _;
    }
    modifier allQuestionsRevealed()
    {
        require(questionRevealed == totalQuestions, "All the questions are not revealed");
        _;
    }
    constructor (bytes32 _name) public
    {
        quizMaster = msg.sender;
        name = _name;
    }
    
    function initialize_game_by_manager(uint8 _n, string q1, string q2, string q3, string q4, string a1, string a2, string a3, string a4, uint8 fee) public
    onlyQuizMaster()
    {
        string[] ques;
        ques.push(q1);
        ques.push(q2);
        ques.push(q3);
        ques.push(q4);
        string[] ans;
        ans.push(a1);
        ans.push(a2);
        ans.push(a3);
        ans.push(a4);
        n = _n;
        participationFee = fee;
        
        for(uint i=0; i< totalQuestions; i++)
        {
            questions.push(ques[i]);
            answers.push(ans[i]);
        }
    }
    function registerPlayers(uint8 initialAccount) public
    notQuizMaster()
    notAlreadyRegistered()
    checkAccountBalance(initialAccount)
    checkIfPlayersNotMoreThanN()
    {
        participantsRegistered++; 
        participantNumber[msg.sender] = participantsRegistered;
        
        Player newPlayer;
        newPlayer.account = initialAccount - participationFee;
        tFee += participationFee;
        
        participants.push(newPlayer);
    }
    
    function endQuiz()
    onlyQuizMaster()
    allQuestionsRevealed()
    {
        tFee = 0;
        questionRevealed = 0;
        participantsRegistered = 0;
        
        address playerAddress;
        for(uint i=0; i< participants.length; i++)
        {
            playerAddress = participants[i].playerId;
            delete participantNumber[playerAddress];
        }
        delete participants;
        delete questions;
        delete answers;
    }
    
}
