FROM node:7.8.0

# Add build argument for port
ARG PORT=3000
ENV PORT=$PORT

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE $PORT
CMD [ "npm", "start" ]