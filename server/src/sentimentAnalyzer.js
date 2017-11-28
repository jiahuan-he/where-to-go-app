/**
 * 
 * @param {Object} client 
 * @param {Object} text 
 * @param {Function} callback 
 */
module.exports = (client, text, callback) => {    
    
    client.analyzeSentiment({document: text})        
        .then(results => {
            const analyzedResult = {"document": {}, "sentences": []}            
            const sentiment = results[0].documentSentiment;
            const docSentimentScore = sentiment.score 
            const docSentimentMagnitude = sentiment.magnitude
            
            analyzedResult.document.score = docSentimentScore
            analyzedResult.document.magnitude = docSentimentMagnitude
            
            // console.log(`Document sentiment:`);
            // console.log(`  Score: ${sentiment.score}`);
            // console.log(`  Magnitude: ${sentiment.magnitude}`);

            const sentences = results[0].sentences;

            sentences.forEach(sentence => {
                const sentenceResult = {}
                sentenceResult.text = sentence.text.content
                sentenceResult.score = sentence.sentiment.score
                sentenceResult.magnitude = sentence.sentiment.magnitude

                // console.log(`Sentence: ${sentence.text.content}`);
                // console.log(`  Score: ${sentence.sentiment.score}`);
                // console.log(`  Magnitude: ${sentence.sentiment.magnitude}`);
                analyzedResult.sentences.push(sentenceResult)
        });
            // console.log(analyzedResult.document.score)
            // console.log(analyzedResult.document.magnitude)
            callback(analyzedResult)
        })
        .catch(err => {
            console.error('ERROR:', err);
        });        
}
