#FROM node:12-alpine as build-stage


#WORKDIR /app

# install and cache app dependencies
#COPY . /app/
#COPY package.json /app/package.json
#RUN npm install
# build production
#RUN npm run build

FROM nginx:1.15

COPY /build/web /usr/share/nginx/html
COPY /nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 433
#COPY --from=build-stage /nginx.conf /etc/nginx/conf.d/default.conf
#CMD ["npm", "start"]

#XPOSE 3000 