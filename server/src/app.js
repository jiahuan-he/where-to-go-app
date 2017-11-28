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

// const document = {
//   content: "Best dim sum in town.  Great staff, always friendly and remember your name.  They are super busy at rush, so get their early.  The quality of their food is amazing.  My personal favourite are the steamed pork buns. Somehow, worst experience I've had at a restaurant yet in Saskatoon. I have eaten at many different places here, but this one takes the cake! Food was bland, barely hot, and they give you these tiny little plates to eat off of. Servers were severely rude. Went into the restaurant, was seated at a table, or more or less told to sit at one of the numbers, no sweat, seated..was given a menu, no problem...order taken, food brought out and then immediately ignored. Until the one waiter who looked like an extra out of the goonies parks the waste cart directly behind my seat, and so as to not offend the Asian family in the corner he leaves the full and smelly waste cart behind my seat. I ask the waitress for some water and ask her to remove the stinking cart behind me. She then starts mumbling in her own language, then goes to make plate sets and her co-worker goes by her and they both looked over at our table and had the gall to laugh about it.  I'm not stupid, so I took my complaint to the person behind the till and discussed everything, he seemed more concerned about it than the wait staff, however, after all is said and done, and a couple hours on the toilet, I will not be returning too that waste dump...it was my first and last time to go there...if I could rate less than one star, I would gladly... Dim Sum is a hit or miss sometimes. I've had times where it was very good and times where it disappointed . Parking is a bit of nightmare and hopefully their new location in Stonebridge alleviates that. Wait times varies depending if you're a group of two or seven or more. We always order for take out.  It can be pricey, but if you like Chinese food where every dish actually tastes like a different dish then this is your place!  This isn't Americanized Chinese food to the same degree as you get in a mall.  It has some authenticity. ",
//   type: 'PLAIN_TEXT'
// };
// syntaxAnalyzer(client, document, (result) => {
//   Object.keys(result).forEach( (key) => {
//     console.log(key+ " : "+ result[key])
//   })
// })

// Start the server
const PORT = process.env.PORT || 8081;
app.listen(PORT, () => {
  console.log(`App listening on port ${PORT}`);
  console.log('Press Ctrl+C to quit.');
});

