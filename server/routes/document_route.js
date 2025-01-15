const express = require('express');
const mongoose = require('mongoose');
const Document = require('../models/document_model');
const authMiddleware = require('../middlewares/auth_middleware');
const documentRouter = express.Router();

documentRouter.post('/api/doc/create' , authMiddleware , async (req,res)=>{
    try{
        const { createdAt } = req.body;

        let document = new Document({
            uid:req.id,
            title : "Untitled Document",
            createdAt : createdAt || Date.now(),
        });

        document = await document.save(); 
        
        res.json({ document });

    }catch(error){
        console.error(error.message);

        if (error instanceof mongoose.Error.ValidationError) {
            return res.status(400).json({ message: 'Validation Error', errors: error.errors });
        }
        
        return res.status(500).json({
            message:error.message
        });
    }
});


documentRouter.get('/api/docs/me' , authMiddleware ,async (req , res)=>{
    
    try{
        const documents = await Document.find({
            uid:req.id
        });

        return res.json(documents);

    }catch(error){
        console.error(error.message);

        if (error instanceof mongoose.Error.ValidationError) {
            return res.status(400).json({ message: 'Validation Error', errors: error.errors });
        }
        
        return res.status(500).json({
            message:error.message
        });
    }



})

module.exports = documentRouter; 




