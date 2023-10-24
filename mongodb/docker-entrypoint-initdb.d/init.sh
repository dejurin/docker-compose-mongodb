#!/bin/bash

if [[ -f "${MONGO_INIT_COMPLETE_FILE_PATH}" ]]; then
  echo "MongoDB initiation has been completed."
else
   # Create a MongoDB user
  mongosh -u "${MONGO_INITDB_ROOT_USERNAME}" -p "${MONGO_INITDB_ROOT_PASSWORD}" --port "${MONGO_PORT}" <<EOF
    use ${APP_MONGO_DATABASE}
    db.createUser({
      user: "${APP_MONGO_USERNAME}",
      pwd: "${APP_MONGO_PASSWORD}",
      roles: [ {
        role: "readWrite",
        db: "${APP_MONGO_DATABASE}",
      } ]
    })
    db.createCollection("initDB")
    db.initDB.insertOne({
        createdAt: new Date(),
    })
EOF
  # Timeout
  sleep 5
  # Create file
  touch "${MONGO_INIT_COMPLETE_FILE_PATH}"
  echo "The creation of the MongoDB user and database is complete."
fi
