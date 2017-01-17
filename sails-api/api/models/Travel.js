module.exports = {
    autoCreatedAt: false,
    autoUpdatedAt: false,
    autoPK: false,
    attributes: {
        traval_id: {
            type: "integer",
            unique: true,
            index: true,
            primaryKey: true
        },
        employee_name: {
            type: "string",
            required: true
        },
        advance: {
            type: "string"
        },
        travel_date: {
            type: "date"
        },
         is_active: {
            type: "number"
        }
    }
};
