pragma solidity ^0.4.0;

contract Quiz
{
    address quizMaster;
    address[] answereSubmittedBy;
    string name;
    
    //number of players that can participate
    uint n;
    uint factor;
    uint totalQuestions;
    uint questionRevealed;
    uint participantsRegistered;
    uint participationFee;
    uint tFee;
    uint registrationDeadline;
    uint answerSubmissionTime;
    
    string prevAns;
    event Print(bytes32);
    
    bool QAadded;
    bool quizStarted;
    event printQuestion(string);
    event printInt(uint);
    uint maxRewardInQuiz;
    struct Player
    {
        address playerId;

        bool answered;
        //account of a player
        uint account;
        //total reward gained in the quiz
        uint reward;
    }
    
    string[] questions;
    string[] correctAnswers;
    Player[] participants;
    mapping (address => uint) participantNumber ;
    
    bool evalDone;
    bool quizEnded;
    bool[] WinnerForThisQuestion;
    address[] winnersAddress;
    
    constructor (string _name) public
    {
        quizMaster = msg.sender;
        name = _name;
        totalQuestions = 4;
        n = 0;
        questionRevealed = 0;
        participantsRegistered = 0;
        registrationDeadline = 0;
        answerSubmissionTime = 0;
        participationFee = 0;
        tFee = 0;
        QAadded = false;
        quizStarted = false;
        evalDone = false;
        quizEnded = false;
        maxRewardInQuiz = 0;
        for(uint i=0;i<4;i++)
        {
            WinnerForThisQuestion.push(false);
        }
    }
    
    modifier checkIfPlayersNotMoreThanN()
    {
        require ( participantsRegistered <= (n-1), "No more players can participate.");
        _;
    }
    modifier checkIfMOreThanOnePLayer(uint _n)
    {
        require ( _n > 1 , "Need atleast two players.");
        _;
    }
    modifier notQuizMaster()
    {
        require ( !(msg.sender == quizMaster) , "Quiz master cannot be a player.");
        _;
    }
    modifier notPlayer()
    {
        require (participantNumber[msg.sender] > 0 , "Quiz has already initiatized.");
        _;
    }
    modifier notAlreadyRegistered()
    {
        require ( !(participantNumber[msg.sender] > 0) , "You are already registered in the quiz.");
        _;
    }
    modifier checkAccountBalance(uint initialAccount)
    {
        require (initialAccount >= participationFee, "You don't have enough balance in your account to participate.");
        _;
    }
    modifier onlyQuizMaster()
    {
        require(msg.sender == quizMaster, "Only quiz master can reveal a question, start or end the quiz.");
        _;
    }
    modifier allQuestionsRevealed()
    {
        require(questionRevealed == totalQuestions, "All the questions are not revealed.");
        _;
    }
    modifier gameInitialized()
    {
        require(QAadded == true, "Game not initialized, cannot register now or unveil questions !!!!");
        _;
    }
    
    modifier notAllQuestionsRevealed()
    {
        require(questionRevealed <= (totalQuestions-1), "All questions have been revealed.");
        _;
    }
    modifier playersMoreThanOne()
    {
        require(participantsRegistered >1, "Atleast 2 players required!");
        _;
    }
    modifier checkIfQuizCanBeStarted()
    {
        require(now > registrationDeadline, "Registration is still going on.");
        _;
    }
    modifier registrationDeadlineExceeded()
    {
        require(now <= registrationDeadline, "Registration is now closed !!");
        _;
    }
    modifier answerSubmissionTimeExceeded()
    {
        require(now <= answerSubmissionTime, "Cannot submit answers anymore !!");
        _;
    }
    modifier answerAlreadySubmitted()
    {
        uint index = participantNumber[msg.sender];
        Player participantIndex = participants[index - 1];
        
        require( participantIndex.answered == false, "You already submitted answer to this question.");
        _;
    }
    modifier prevQuestionTimeExceeded()
    {
        require(now > answerSubmissionTime , "Cannot unveil next question until previous question is open!");
        _;
    }
    modifier afterSubmission()
    {
        require(now > answerSubmissionTime, "All players not submitted the answer!");
        _;
    }
    modifier afterEvaluation()
    {
        require( evalDone == true, "Quiz is not finished yet.");
        _;
    }
    modifier prevQuizEnded()
    {
        require(quizEnded == true, "Cannot initialize new quiz until already a quiz is going on!");
        _;
    }
    modifier registered()
    {
        require(!(participantNumber[msg.sender] == 0), " You are not registered for this quiz! ");
        _;
    }
    
    function initialize_game_by_manager(uint _n, string q1, string q2, string q3, string q4, string a1, string a2, string a3, string a4, uint fee, uint registrationTimeLimit) public
    onlyQuizMaster()
    checkIfMOreThanOnePLayer(_n)
    {

        questions.push(q1);
        questions.push(q2);
        questions.push(q3);
        questions.push(q4);
        
        correctAnswers.push(a1);
        correctAnswers.push(a2);
        correctAnswers.push(a3);
        correctAnswers.push(a4);
        n = _n;
        factor = 16;
        participationFee = fee;
        registrationDeadline = now + registrationTimeLimit;
        
        QAadded = true;
        quizStarted = false;
        quizEnded = false;
        tFee = n * fee;
    }
    
    function registerPlayers(uint initialAccount) public
    gameInitialized()
    registrationDeadlineExceeded()
    notQuizMaster()
    notAlreadyRegistered()
    checkIfPlayersNotMoreThanN()
    checkAccountBalance(initialAccount)
    {
        address temp = quizMaster;
        uint temp2 = n;
        uint temp3 = totalQuestions;
        uint temp4 = registrationDeadline;
        
        uint t = participantsRegistered + 1; 
        
        participantNumber[msg.sender] = t;
        
        Player newPlayer;
        newPlayer.playerId = msg.sender;
        newPlayer.answered = false;
        newPlayer.reward = 0;
        newPlayer.account = initialAccount - participationFee;
        
        participants.push(newPlayer);
        
        quizMaster = temp;
        n= temp2;
        totalQuestions = temp3;
        registrationDeadline = temp4;
        participantsRegistered = t;
    }
    
    function unveilQuestion()
    checkIfQuizCanBeStarted()
    onlyQuizMaster()
    gameInitialized()
    playersMoreThanOne()
    prevQuestionTimeExceeded()
    notAllQuestionsRevealed() returns (string)
    {
        for(uint i=0; i<participants.length; i++)
        {
            participants[i].answered = false;
        }
        quizStarted = true;
        uint temp = questionRevealed + 1;
        
        questionRevealed = temp;
        answerSubmissionTime = now + 26;
        emit printQuestion(questions[temp-1]);
    }
    
    function submitAnswers(string ans)
    notQuizMaster()
    registered()
    answerSubmissionTimeExceeded()
    answerAlreadySubmitted()
    {
        uint temp = questionRevealed;

        if((WinnerForThisQuestion[temp - 1] == false) && (keccak256(ans) == keccak256(correctAnswers[temp-1])))
        {
            uint temp2 = factor;
            WinnerForThisQuestion[temp-1] = true;
            uint currentPlayerIndex = participantNumber[msg.sender] ;
            participants[currentPlayerIndex-1].reward += (factor * temp2);
            factor = temp2 - 3;
            
            if(participants[currentPlayerIndex-1].reward > maxRewardInQuiz)
            {
                maxRewardInQuiz = participants[currentPlayerIndex-1].reward;
            }
        }
        questionRevealed = temp;
    }

    function quizEvaluate()
    onlyQuizMaster()
    afterSubmission()
    allQuestionsRevealed()
    {

        for(uint i = 0; i<participants.length; i++)
        {
            Player p = participants[i];
            if( p.reward == maxRewardInQuiz )
            {
                winnersAddress.push(p.playerId);
            }
        }
        evalDone = true;
    }

    function getWinner()
    onlyQuizMaster()
    afterEvaluation() view returns (address[])
    {
        return (winnersAddress);
    }

    function endQuiz()
    onlyQuizMaster()
    {
        tFee = 0;
        questionRevealed = 0;
        participantsRegistered = 0;
        maxRewardInQuiz = 0;
        evalDone = false;
        quizEnded = true;
        n = 0;
        
        address playerAddress;
        for(uint i=0; i< participants.length; i++)
        {
            playerAddress = participants[i].playerId;
            delete participantNumber[playerAddress];
        }
        for(uint j=0;j<4;j++)
        {
            WinnerForThisQuestion[j] = false;
        }
        delete participants;
        delete questions;
        delete correctAnswers;
        delete WinnerForThisQuestion;
        delete winnersAddress;
    }
    function getBalance(address addr) returns(uint){
        return participants[participantNumber[addr]].account;
    }
}
