const express = require('express');
const mongoose = require('mongoose');
const User  = require("../models/user_model");
const jwt = require("jsonwebtoken");
const UserModel = require('../models/user_model');
const authMiddleware = require('../middlewares/auth_middleware');
const {z} = require('zod');

const authRouter = express.Router();


authRouter.get('/test' , (req,res)=>{
    console.log(`$req.server is asking for the server `);
    res.json({
        message:"Welcome to Ashmit Server!"
    });
});

authRouter.post('/api/signup' , async (req , res)=>{

    try{
        const requiredBody = z.object({
            name:z.string().min(2),
            email:z.string().email().min(5),
            profilePic:z.string()
        });

        const parseDataWithSuccess = requiredBody.safeParse(req.body);
        if(!parseDataWithSuccess.success){
            return res.status(400).json({
                message: "Incorrect Format",
                error : parseDataWithSuccess.error
            });
        }

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
        console.log("the user has signed up : " ,user);

        const token = jwt.sign({
            id : user._id,
        }, process.env.JWT_SECRET);

        res.status(200).json({ user , token });

    }catch(error){
        console.error("Error while sending " , error.message);
        res.status(400).json({
            message : error.message
        });
    }

});

authRouter.get('/' , authMiddleware ,async (req , res)=>{

    try{    
        // const userInfo = await UserModel.find({
        //     _id : req.id
        // });

        const userInfo = await UserModel.findById(req.id);
        
        if (!userInfo) {
            return res.status(404).json({ message: "User not found" });
        }

        res.json({
            userData:userInfo,
            token : req.token
        });

    }catch(error){
        console.error(error.message);
        res.status(500).json({
            message:"Server error : ",error: error.message
        });
    }
});



module.exports = authRouter;