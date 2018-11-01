var Quiz = artifacts.require("Quiz");
function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

contract('Quiz', function(accounts) {


  // test case 1 to check if players not more than n
  it("Quiz master cannot be a player!", function() {
     
      Quiz.deployed().then( async function(instance){

        await instance.initialize_game_by_manager(2,"w","x","y","z","a","b","c","d",20,30, {from: accounts[0]});
        return instance;
      }).then(async function(instance){

        await instance.registerPlayers(100, {from: accounts[0]});
        return instance;
      }).then(async function(instance){

        await instance.registerPlayers(150, {from: accounts[2]});
        return instance;
      }).then(async function(instance){

        await instance.registerPlayers(120, {from: accounts[3]});
        return instance;
      }).then(async function(instance){

await sleep(30000);
		await instance.unveilQuestion({from: accounts[0]});
         return instance;
      }).then(async function(instance){

      	await instance.submitAnswers("a", {from: accounts[2]});
         return instance;
      }).then(async function(instance){

// await sleep(30000);
      	await instance.submitAnswers("1", {from: accounts[3]});
         return instance;
      }).then(async function(instance){
await sleep(30000);
      	await instance.unveilQuestion({from: accounts[0]});
         return instance;
      }).then(async function(instance){
// await sleep(30000);
      	await instance.submitAnswers("b", {from: accounts[2]});
         return instance;
      }).then(async function(instance){
// await sleep(30000);
		await instance.submitAnswers("a", {from: accounts[2]});
         return instance;
      }).then(async function(instance){
await sleep(30000);
      	await instance.unveilQuestion({from: accounts[0]});
         return instance;
      }).then(async function(instance){
// await sleep(30000);
		await instance.submitAnswers("a", {from: accounts[2]});
         return instance;
      }).then(async function(instance){
      	await instance.submitAnswers("c", {from: accounts[2]});
         return instance;
      }).then(async function(instance){
await sleep(30000);
      	await instance.unveilQuestion({from: accounts[0]});
         return instance;
      }).then(async function(instance){
      	await instance.submitAnswers("d", {from: accounts[2]});
         return instance;
      }).then(async function(instance){
      	await instance.submitAnswers("4", {from: accounts[3]});
         return instance;
      }).then(async function(instance){
await sleep(30000);
      	await instance.quizEvaluate({from: accounts[1]});
         return instance;
      }).then(async function(instance){

      	result = await instance.getWinner.call();
      	console.log(result);
        // assert.equal(result[0], accounts[1], 'Wrong second winner!');
      });
  });

});
