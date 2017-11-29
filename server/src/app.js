// Imports the Google Cloud client library
const language = require('@google-cloud/language');

// Instantiates a client
const client = new language.LanguageServiceClient();

// app setup
const express = require("express")
const app = express()
const sentimentAnalyzer = require("./sentimentAnalyzer")
const entitiesAnalyzer = require("./entitiesAnalyzer")
const syntaxAnalyzer = require("./syntaxAnalyzer")
const axios = require("axios")

const key = process.env.API_KEY
const bodyParser = require('body-parser') 
app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json());

app.get('/', (req, res) => {
    res.status(200).send('Hello, world swift !').end();
  });

// By RESTful convension, a /get is needed here 
// But in this case, the length of the query string exceeds 1024 bytes
// So /post is used instead 
// app.post('/sentiment', (req, res) => {  
  
//   const content = req.body.content
//   const document = {content: content, type: 'PLAIN_TEXT'};

//   // result: Object:  {
//   //                    "document": {score:number, magnitude: number}, 
//   //                    "sentences": []Object{text: string, score:number, magnitude: number}
//   //                  }
//   sentimentAnalyzer(client, document, (result) => res.json(result))
// })

// app.post("/entities", (req, res) => {
//   const content = req.body.content
//   const document = {content: content, type: 'PLAIN_TEXT'};

//   const filter = {
//     "minAbsScore": 0.5, 
//     "minMagnitude": 0.5, 
//     "minSalience": null
//   }
//   entitiesAnalyzer(client, document, (result) => res.json(result), filter)
// })

getURL = (pid, key) => {
  return `https://maps.googleapis.com/maps/api/place/details/json?placeid=${pid}&key=${key}`
}

app.get("/:pid/reviews",(req, res) => {
  const pid = req.params.pid
  console.log(`get /${pid}/reviews`)
  axios.get(getURL(pid, key))
    .then( (googleRes) => {
      const result = {
        "openNow": googleRes.data.result.opening_hours.open_now,
        "reviews": googleRes.data.result.reviews
      }
      res.json(result)
    })
    .catch( (error) => {
      console.log(error);      
    })
})

app.get("/analysis/entities",(req, res) => {  
  const pid = req.query.pid
  console.log(`get /analysis/entities?pid=${pid}`)
  axios.get(getURL(pid, key))
  .then( (googleRes) => {
    const rawReviews = googleRes.data.result.reviews
    const reviews = Object.keys(rawReviews).map( (key) => rawReviews[key].text) 
    const filter = {
      "minAbsScore": null, 
      "minMagnitude": null, 
      "minSalience": null
    }
    const joinedReview = reviews.join("")    
    const document = {content: joinedReview, type: 'PLAIN_TEXT'};
    entitiesAnalyzer(client, document, (result) => res.json(result), filter)    
  })
  .catch( (error) => {
    console.log(error);      
  })
})

//change from get to post to make it easier to send array
app.post("/analysis/sentiment",(req, res) => {
  console.log("post /analysis/sentiment")
  const pids = req.body.pids
  const count = pids.length
  let i = 0
  const joinedReviewArray = []
  pids.forEach(pid => {
    axios.get(getURL(pid, key))
    .then( (googleRes) => {
      const rawReviews = googleRes.data.result.reviews
      const reviews = Object.keys(rawReviews).map( (key) => rawReviews[key].text) 
      const joinedReview = reviews.join("")    
      joinedReviewArray.push(joinedReview)
      i++
      if(i >= count){
        const document = {content: joinedReviewArray.join(""), type: 'PLAIN_TEXT'};      
        sentimentAnalyzer(client, document, (result) => res.json(result))
      }
    })
    .catch( (error) => {
      console.log(error);      
    })
  });
})

// Start the server
const PORT = process.env.PORT || 8081;
app.listen(PORT, () => {
  console.log(`App listening on port ${PORT}`);
  console.log('Press Ctrl+C to quit.');
});

