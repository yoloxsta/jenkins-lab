<<<<<<< HEAD
# stage 1:
=======
#Stage 1:
>>>>>>> fd925198865e6210f882b2dde1f458ebb1807b7e
FROM node:14 as builder
WORKDIR /app
COPY package*.json ./ 
RUN npm install
COPY . .   
RUN npm run build
 
# Stage 2:
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
# COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
