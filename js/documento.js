document.addEventListener("DOMContentLoaded",() =>{
    // const tagOption = document.querySelector("#")
    const optionDoc = document.querySelector("#idtipodocumento");

    (() =>{
        fetch(`../../controller/documento.controller.php`)
            .then(response => response.json())
            .then(data =>{
                data.forEach(element => {
                    const tagOption = document.createElement('option');
                    tagOption.value = element.idtipodocumento;
                    tagOption.innerText= element.documento;
                    optionDoc.appendChild(tagOption);
                });
            })
            .catch(e =>{
                console.error(e);
            })
    })();

})