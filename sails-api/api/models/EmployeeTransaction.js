module.exports = {
    autoCreatedAt: false,
    autoUpdatedAt: false,
    autoPK: false,
    attributes: {
        employee_transaction_id: {
            type: "integer",
            unique: true,
            index: true,
            primaryKey: true
        },
        type: {
            type: "integer",
            required: true
        },
        employee_id: {
            type: "integer",
            required: true
        },
        amount: {
            type: "decimal",
            require: true
        },
        date: {
            type: "date",
            require: true
        },

    }
};