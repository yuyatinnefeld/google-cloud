FROM node:12-slim
WORKDIR /usr/src/app
RUN npm install -g @angular/cli
COPY my-app ./
RUN npm install
RUN npm run build
EXPOSE 8080
CMD [ "node", "server.js" ]