# this version is of 187 mb

FROM  node:current-alpine3.20


WORKDIR /google-Docs-Server

COPY package.json package.json 
COPY package-lock.json package-lock.json
# RUN npm install
RUN npm ci


COPY . .
RUN echo 'the server is starting please wait !!'

# RUN npm run build
EXPOSE 3000

CMD ["npm","run" , "dev"]
# CMD ["npm","start"]       




# optimized version using (152 mb)
# 1. lighter versions or alpine versions 
# 2. Layer Caching 
# 3. using dockerignore 
# 4. multi stage build  

# Stage 1: Builder (Installs Dependencies)
# FROM node:20-alpine AS builder

# WORKDIR /app

# COPY package.json package-lock.json ./

# # only installs the production dependencies , clean install 
# # RUN npm ci --only=production 
# RUN npm ci 

# COPY . .

# RUN echo 'Stage 1 is completed -> installing dependencies completed'

# FROM node:20-alpine

# WORKDIR /app

# # Copy only necessary files from builder stage
# COPY --from=builder /app/node_modules ./node_modules
# COPY --from=builder /app/app.js ./app.js
# COPY --from=builder /app/package.json ./

# EXPOSE 3000

# # CMD ["npm", "run", "dev"]
# CMD ["node", "app.js"]


