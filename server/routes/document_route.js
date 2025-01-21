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
});


//this will update the document title 
documentRouter.post('/api/docs/update' , authMiddleware , async (req , res ) =>{
    
    try{
        const { documentId , docTitle} = req.body;

        await Document.findByIdAndUpdate(documentId , {
            title : docTitle,
        })
        return res.json({
            message:"document updated successfully!!",
        });

    }catch(e){
        console.error(error.message);
        if (error instanceof mongoose.Error.ValidationError) {
            return res.status(400).json({ message: 'Validation Error', errors: error.errors });
        }
    
        return res.status(500).json({
            message:error.message
        });
    }

});


documentRouter.get('/api/doc/:id' , authMiddleware ,async (req , res)=>{
    
    try{
        const document = await Document.findById(req.params.id);

        return res.json(document);

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


module.exports = documentRouter; 




