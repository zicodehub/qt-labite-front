function fetch(opts) {
    return new Promise(function (resolve, reject) {
        var xhr = new XMLHttpRequest()
        xhr.onload = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status == 200 || xhr.status == 201) {
                    var res = xhr.responseText.toString()
                    resolve(res)
                } else {
                    let r = {
                        "status": xhr.status,
                        "statusText": xhr.statusText,
                        "content": xhr.responseText
                    }
                    reject(r)
                }
            } else {
                let r = {
                    "status": xhr.status,
                    "statusText": xhr.statusText,
                    "content": xhr.responseText
                }
                reject(r)
            }
        }
        xhr.onerror = function () {
            let r = {
                "status": xhr.status,
                "statusText": 'NO CONNECTION, ' + xhr.statusText + xhr.responseText
            }
            reject(r)
        }

        xhr.open(opts.method ? opts.method : 'GET', opts.url, true)

        if (opts.headers) {
            Object.keys(opts.headers).forEach(function (key) {
                xhr.setRequestHeader(key, opts.headers[key])
            })
        }

        let obj = opts.params

        var data = obj ? JSON.stringify(obj) : ''

        xhr.send(data)
    })
}

function request(method, url, params) {
    let query = {
        "method": method,
        "url": url,
        "headers": {
            "Accept": 'application/json',
            "Content-Type": 'application/json'
            //            "Authorization": "Bearer pNf383r7bFud-1ppHM9ANayVTfJyJRuj"
        },
        "params": params ?? null
    }
    return fetch(query)
}

function getAssetURL(directus_files_id) {
    if (!directus_files_id) {
        return ""
    } else
        return "https://blume.mahoudev.com/assets/" + directus_files_id
}

function parseQuery(filters) {
    let query = ""
    for (let key in filters) {
        let value = filters[key]

        //        if(typeof value === 'object') {
        //            parseQuery(value)
        //        } else query += `${key}=${value}&`
        query += `${key}=${value}&`
    }
    return query
}

function filterPlants(filters = {
                      "limit": 4
                      }) {
    let query = parseQuery(filters)
    const url = "https://blume.mahoudev.com/items/Plantes?" + query
    return request("GET", url)
}

function retrieveTrefleSpecie(trefle_id) {
    const url = `https://trefle.io/api/v1/species/${trefle_id}?token=t0_Kvv9eAi9Wb2z-MOXXmCI3G1aiJZam4z3G18mHsfg`
    console.log(url)
    return request("GET", url)
}

function setPlantEquivalent(blume_id, trefle_id) {
    if (!blume_id)
        throw "blume_id is mandatory"
    if (trefle_id !== null) {
        if (typeof trefle_id !== 'number')
            throw "trefle_id me be a number"
        if (Number.isNaN(trefle_id))
            throw "trefle_id must be valid number, not NaN"
        if (trefle_id < 1)
            throw "trefle_id must be gt than 1"
    }

    const url = "https://blume.mahoudev.com/items/Plantes/" + blume_id
    console.log(url)
    let query = {
        "method": "PATCH",
        "url": url,
        "headers": {
            "Accept": 'application/json',
            "Content-Type": 'application/json',
            "Authorization": "Bearer pNf383r7bFud-1ppHM9ANayVTfJyJRuj"
        },
        "params": {
            "trefle_id": trefle_id
        }
    }
    return fetch(query)
}
