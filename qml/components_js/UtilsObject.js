function replaceNullWithEmptyString(obj) {
    for (let key in obj) {
        if (obj[key] === null) {
            delete obj[key]
        } else if (typeof obj[key] === "object") {
            replaceNullWithEmptyString(obj[key])
        }
    }
    return obj
}
