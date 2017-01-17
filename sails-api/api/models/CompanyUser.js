

module.exports = {
    attributes: {
        company_user_id: {
            type: "integer",
            required: true,
            unique: true,
            index: true,
            primaryKey: true
        },

        company_id: {
            type: "integer",
            required: true
        },
        user_id: {
            type: "integer",
            required: true
        }
    }
};