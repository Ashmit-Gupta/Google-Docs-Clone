const jwt = require('jsonwebtoken');

const authMiddleware = async(req , res , next)=>{
    const token = req.headers.token;

    if(!token){
        return res.status(401).json({
            message:"Token is Required",
        });
    }

    try{
        const verified =  jwt.verify(token , process.env.JWT_SECRET);

        if(verified){
            
            req.id = verified.id;
            req.token = token;

            return next();
        }else{
            return res.status(401).json({
                message : "Invalid Token , Authorization Denied!!"
            });
        }

    }catch(error){
        console.error("JWT Verification Error: ", error.message);

        return res.status(401).json({
            message:"Invalid or expired token."
            ,error:error.message
        })
    }
}

module.exports = authMiddleware;