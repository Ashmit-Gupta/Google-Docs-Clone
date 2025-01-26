require('dotenv').config();
const express = require('express');
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
const authRouter = require('./routes/auth_route');
const http = require('http');
const cors = require('cors');
const documentRouter = require('./routes/document_route');

const PORT = process.env.PORT || 3000 || 3001;

const app = express();

var server = http.createServer(app);
var io = require('socket.io')(server);

app.use(cors());
app.use(express.json());

app.use(authRouter); //authentication Router 
app.use(documentRouter); //creating a document router 


// WebSocket connection handling
io.on('connection', (socket) => {
    console.log('Socket connected:', socket.id);

    socket.on('join', (documentId) => {
        socket.join(documentId);
        console.log(`Socket ${socket.id} joined room: ${documentId}`);
    });


    socket.on('typing' , (data)=>{
        socket.broadcast.to(data.room).emit('changes',data);
    });

    socket.on('save' ,(data)=>{
        saveData(data);
        // io.to();
    });
});

const saveData = async(data)=>{
    let document = await Document.findById(data.room);
    document.content = data.delta;
    document = await document.save();
}

server.listen(PORT , "0.0.0.0" ,async ()=>{

    console.log("The server is runing ", PORT);
    
    try {
        if (!process.env.DB_CONNECTION) {
            throw new Error('Missing DB_CONNECTION in environment variables');
        }
    
        const connection = await mongoose.connect(process.env.DB_CONNECTION, {
            // useNewUrlParser: true,
            useUnifiedTopology: true,
        });
    
        console.log('Connected to the Database Successfully');
    } catch (error) {
            console.error('Error while running the server:', error.message);
            process.exit(1); // Exit process on critical failure
        }
    });