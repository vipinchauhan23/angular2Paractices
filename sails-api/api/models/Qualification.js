module.exports = {
    autoCreatedAt: false,
    autoUpdatedAt: false,
    autoPK: false,
    attributes: {
        qualification_id: {
            type: "integer",
            unique: true,
            index: true,
            primaryKey: true
        },
        qualification_name: {
            type: "string",
            required: true
        },
      
    }
};