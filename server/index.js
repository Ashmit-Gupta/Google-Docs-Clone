require('dotenv').config();
const express = require('express');
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
const authRouter = require('./routes/auth_route');
const cors = require('cors');
const documentRouter = require('./routes/document_route');

const PORT = process.env.PORT || 3000 || 3001;

const app = express();

app.use(cors());
app.use(express.json());

app.use(authRouter); //authentication Router 
app.use(documentRouter);//creating a document router 

app.listen(PORT , "0.0.0.0" ,async ()=>{

    console.log("The server is runing ", PORT);
    
    try{
        const connection =  await mongoose.connect(process.env.DB_CONNECTION);

        if(connection){
            console.log("Connected to the Database Successfully");
        }else{
            console.error("Error while Connecting to the Database");
        }

    }catch(e){
        console.error("Error while runing the server : " , e.message);
    }
});