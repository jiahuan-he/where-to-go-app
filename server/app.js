// Imports the Google Cloud client library
const express = require("express")
const app = express()
const documentAnalizer = require("./documentSentimentAnalizer")
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
  documentAnalizer(document, (result) => res.json(result))
  
})

// Start the server
const PORT = process.env.PORT || 8081;
app.listen(PORT, () => {
  console.log(`App listening on port ${PORT}`);
  console.log('Press Ctrl+C to quit.');
});

