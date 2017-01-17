module.exports = {
    autoCreatedAt: false,
    autoUpdatedAt: false,
    autoPK: false,
    attributes: {
        employeerecord_id: {
            type: "integer",
            unique: true,
            index: true,
            primaryKey: true
        },
        employee_id: {
            type: "integer",
            required: true
        },
        qualification_id: {
            type: "integer",
            required: true
        }
    }
};
