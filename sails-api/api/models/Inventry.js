module.exports = {
    autoCreatedAt: false,
    autoUpdatedAt: false,
    autoPK: false,
    attributes: {
        item_sale_purchase_id: {
            type: "integer",
            unique: true,
            index: true,
            primaryKey: true
        },
        type: {
            type: "integer",
            required: true
        },
        name: {
            type: "string",
            required: true
        },
        address: {
            type: "string",
            required: true
        },
        mobile_no: {
            type: "string"
        },
         tin_no: {
            type: "string"
        },
        total: {
             type: "decimal"
        }
    }
};