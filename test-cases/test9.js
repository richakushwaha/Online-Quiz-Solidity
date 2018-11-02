var Quiz = artifacts.require("Quiz");
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

contract('Quiz', function(accounts) {


  // test case 1 to check if players not more than n
  it("Balances are correct", function() {
     
      Quiz.deployed().then( async function(instance){

        await instance.initialize_game_by_manager(4,"Is delhi in India?", "Is Rice a grain?", "Rank of India in Army Strength", "Capital of Belgium", "yes", "yes", "4", "Brussels", 50,30, {from: accounts[0]});
        return instance;
      }).then(async function(instance){

        await instance.registerPlayers(100, {from: accounts[1]});
        return instance;
      }).then(async function(instance){

        await instance.registerPlayers(150, {from: accounts[2]});
        return instance;
      }).then(async function(instance){
        var x1 = instance.getBalance({from: accounts[2]});
        assert.equal(100, x1.toNumber(), "Fees is taken");
        x1 = instance.getBalance({from: accounts[1]});
        assert.equal(50, x1.toNumber(), "Fees is taken");
      });
  });

});