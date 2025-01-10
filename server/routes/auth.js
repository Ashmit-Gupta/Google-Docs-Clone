const express = require('express');
const mongoose = require('mongoose');
const User  = require("../models/user_model");


const authRouter = express.Router();


authRouter.get('/' , (req,res)=>{
    console.log(`$req.server is asking for the server `);
    res.json({
        message:"Welcome to Ashmit Server!"
    });
});

authRouter.post('/api/signup' , async (req , res)=>{

    try{
        const {name , email , profilePic} = req.body;
        
        let user = await User.findOne({
            email : email,
        });

        if(!user){
            user = new User({
                email ,
                name ,
                profilePic ,
            });
            //storing the data 
            user = await user.save();
        }

        res.status(200).json({ user });

    }catch(error){
        console.error("Error while sending " , error.message);
        res.status(400).json({
            message : error.message
        });
    }


});

module.exports = authRouter;