pragma solidity ^0.4.0;

contract Quiz
{
    address quizMaster;
    string name;
    
    //number of players that can participate
    uint numberOfParticipants;
    uint totalQuestions;
    uint questionRevealed;
    uint participantsRegistered;
    uint participationFee;
    uint tFee;
    bool QAadded;

    struct Player
    {
        address playerId;

        string[] answers ;
        //account of a player
        uint account;
        //total reward gained in the quiz
        uint reward;
    }
    
    string[] questions;
    string[] answers;
    Player[] participants;
    mapping (address => uint) participantNumber ;
    
    modifier checkIfPlayersNotMoreThanN()
    {
        require ( participantsRegistered <= (numberOfParticipants-1), "No more players can participate");
        _;
    }
    modifier checkIfMOreThanOnePLayer(uint _n)
    {
        require ( _n > 1 , "Need atleast two players");
        _;
    }
    modifier notQuizMaster()
    {
        require ( !(msg.sender == quizMaster) , "Quiz master cannot be a player");
        _;
    }
    modifier notPlayer()
    {
        require (participantNumber[msg.sender] > 0 , "Quiz has already initiatized");
        _;
    }
    modifier notAlreadyRegistered()
    {
        require ( !(participantNumber[msg.sender] > 0) , "You are already registered in the quiz");
        _;
    }
    modifier checkAccountBalance(uint initialAccount)
    {
        require (initialAccount >= participationFee, "You don't have enough balance in your account to participate");
        _;
    }
    modifier onlyQuizMaster()
    {
        require(msg.sender == quizMaster, "Only quiz master can start or end the quiz");
        _;
    }
    modifier allQuestionsRevealed()
    {
        require(questionRevealed == totalQuestions, "All the questions are not revealed");
        _;
    }
    modifier gameInitialized()
    {
        require(QAadded == true, "Game not initialized, cannot register now !!!!");
        _;
    }
    constructor (string _name) public
    {
        quizMaster = msg.sender;
        name = _name;
        totalQuestions = 4;
        numberOfParticipants = 0;
        questionRevealed = 0;
        participantsRegistered = 0;
        participationFee = 0;
        tFee = 0;
        QAadded = false;
    }
    
    function initialize_game_by_manager(uint n, string q1, string q2, string q3, string q4, string a1, string a2, string a3, string a4, uint fee) public
    onlyQuizMaster()
    checkIfMOreThanOnePLayer(n)
    {

        questions.push(q1);
        questions.push(q2);
        questions.push(q3);
        questions.push(q4);
        
        answers.push(a1);
        answers.push(a2);
        answers.push(a3);
        answers.push(a4);
        numberOfParticipants = n;
        participationFee = fee;
        
        QAadded = true;
    }
    
    function registerPlayers(uint initialAccount) public
    gameInitialized()
    notQuizMaster()
    notAlreadyRegistered()
    checkIfPlayersNotMoreThanN()
    checkAccountBalance(initialAccount)
    {
        address temp = quizMaster;
        uint playersNumber = numberOfParticipants;
        uint numberOfQuestions = totalQuestions;
        
        uint t = participantsRegistered + 1; 
        
        participantNumber[msg.sender] = t;
        
        Player newPlayer;
        newPlayer.playerId = msg.sender;
        newPlayer.reward = 0;
        newPlayer.account = initialAccount - participationFee;
        tFee += participationFee;
        
        participants.push(newPlayer);
        
        quizMaster = temp;
        numberOfParticipants = playersNumber;
        totalQuestions = numberOfQuestions;
        participantsRegistered = t;
    }
    
    function showParticipantsRegistered() view returns (uint)
    {
        return participantsRegistered;
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