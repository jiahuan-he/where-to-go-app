
// Detects syntax in the document
module.exports = (client, text, callback) => { 
    const analyzedResult = {}
    client
    .analyzeSyntax({document: text})
    .then(results => {
        const syntax = results[0];        
        console.log('Tokens:');
        syntax.tokens.forEach(part => {
        // console.log(`${part.partOfSpeech.tag}: ${part.text.content}`);
            const tag = part.partOfSpeech.tag
            const word = part.text.content
            if(part.partOfSpeech.tag === "ADJ"){
                if(analyzedResult[word]){
                    analyzedResult[word] ++
                } else {
                    analyzedResult[word] = 1
                }
            }
        });
        callback(analyzedResult)
    })
    .catch(err => {
        console.error('ERROR:', err);
  });
}