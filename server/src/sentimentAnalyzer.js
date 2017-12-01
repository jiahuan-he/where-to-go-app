/**
 * 
 * @param {Object} client 
 * @param {Object} text 
 * @param {Function} callback 
 */
module.exports = (client, documents, callback) => {   
    
    let i = 0
    const keys = Object.keys(documents)
    const count = keys.length
    const analyzedResult = {}

    keys.forEach( key => {
        console.log(key)
        client.analyzeSentiment({document: documents[key]})        
        .then(results => {            
            const sentiment = results[0].documentSentiment;
            const docSentimentScore = sentiment.score 
            const docSentimentMagnitude = sentiment.magnitude            
            const currentResult = {
                "score": docSentimentScore,
                "magnitude": docSentimentMagnitude
            }
            analyzedResult[key] = currentResult
            i ++
            if( i >= count){
                callback(analyzedResult)
            }            
        })
        .catch(err => {
            console.error('ERROR:', err);
        });
    })
    
            
}
