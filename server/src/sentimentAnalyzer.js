/**
 * 
 * @param {Object} client 
 * @param {Object} text 
 * @param {Function} callback 
 */
module.exports = (client, text, callback) => {        
    client.analyzeSentiment({document: text})        
        .then(results => {
            const analyzedResult = {
                "document": {}, 
                "sentences": {
                    "positive":[], 
                    "negative":[]
                }
            }  
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
                if(sentenceResult.score > 0 && sentenceResult.magnitude>0){
                    analyzedResult.sentences.positive.push(sentenceResult)
                } else if(sentenceResult.score < 0 && sentenceResult.magnitude>0){
                    analyzedResult.sentences.negative.push(sentenceResult)
                }
        });
            callback(analyzedResult)
        })
        .catch(err => {
            console.error('ERROR:', err);
        });        
}
