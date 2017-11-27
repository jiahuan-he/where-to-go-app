// Imports the Google Cloud client library
const language = require('@google-cloud/language');

// Instantiates a client
const client = new language.LanguageServiceClient();

// app setup
const express = require("express")
const app = express()
const sentimentAnalyzer = require("./sentimentAnalyzer")
const entitiesAnalyzer = require("./entitiesAnalyzer")

const bodyParser = require('body-parser') 
app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json());

app.get('/', (req, res) => {
    res.status(200).send('Hello, world 2 !').end();
  });

// By RESTful convension, a /get is needed here 
// But in this case, the length of the query string exceeds 1024 bytes
// So /post is used instead 
app.post('/sentiment', (req, res) => {  
  
  const content = req.body.content
  const document = {content: content, type: 'PLAIN_TEXT'};

  // result: Object:  {
  //                    "document": {score:number, magnitude: number}, 
  //                    "sentences": []Object{text: string, score:number, magnitude: number}
  //                  }
  sentimentAnalyzer(client, document, (result) => res.json(result))
})

app.post("/entities", (req, res) => {
  const content = req.body.content
  const document = {content: content, type: 'PLAIN_TEXT'};

  const filter = {
    "minAbsScore": 0.5, 
    "minMagnitude": 0.5, 
    "minSalience": null
  }
  entitiesAnalyzer(client, document, (result) => res.json(result), filter)
})



// Start the server
const PORT = process.env.PORT || 8081;
app.listen(PORT, () => {
  console.log(`App listening on port ${PORT}`);
  console.log('Press Ctrl+C to quit.');
});

