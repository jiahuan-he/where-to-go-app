module.exports = (client, text, callback, filter) => {        
    client.analyzeSentiment({document: text})        
        .then(results => {
            const analyzedResult = []
            const sentences = results[0].sentences;
            sentences.forEach(sentence => {
                const sentenceResult = {}
                sentenceResult.text = sentence.text.content
                sentenceResult.score = sentence.sentiment.score
                sentenceResult.magnitude = sentence.sentiment.magnitude
                if(
                    (!filter.minAbsScore || Math.abs(sentenceResult.score)>=filter.minAbsScore)
                    && (!filter.minMagnitude || sentenceResult.magnitude>=filter.minMagnitude)
                )
                {
                    if(sentenceResult.score != 0 && sentenceResult.magnitude != 0){
                        analyzedResult.push(sentenceResult)
                    }
                }                
        });
        const sortedResult = analyzedResult.sort( (item1, item2) => item2.score-item1.score)
        callback(sortedResult)
        })
        .catch(err => {
            console.error('ERROR:', err);
        });        
}
