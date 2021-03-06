/**
 * 
 * @param {*} client 
 * @param {*} text 
 * @param {function} callback 
 * @param {Object} filter 
 * @param {number} filter.minAbsScore
* @param {number} filter.minMagnitude
 * @param {number} filter.minSalience
 */
module.exports = (client, text, callback, filter) => {    
    
    const analyzedResult =  []
    // Detects entities in the document
    client
        .analyzeEntitySentiment({document: text})
        .then(results => {
        const entities = results[0].entities;
        // console.log('Entities:');
        entities.forEach(entity => {
            const item = {
                "name": entity.name, 
                "type": entity.type, 
                "score": entity.sentiment.score, 
                "magnitude":entity.sentiment.magnitude,
                "salience": entity.salience
            }
            
            if( 
                (!filter.minAbsScore || Math.abs(item.score)>=filter.minAbsScore)
                && (!filter.minMagnitude || item.magnitude>=filter.minMagnitude)
                && (!filter.minSalience || item.salience>=filter.minSalience))
            {
                if (item.score !== 0){
                    analyzedResult.push(item)
                }
                // console.log(`  Name: ${item.name}`);
                // console.log(`  Type: ${item.type}`);
                // console.log(`  Score: ${item.score}`);
                // console.log(`  Magnitude: ${item.magnitude}`);  
                // console.log()
                
            }            
        });
            const sortedResult = analyzedResult.sort( (item1, item2) => item2.score-item1.score)
            callback(sortedResult)                                              
        })
        .catch(err => {
        console.error('ERROR:', err);
    });
}