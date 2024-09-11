document.addEventListener("DOMContentLoaded", () =>{
    const dni = document.querySelector("#idpersonanrodoc");
    const doc = document.querySelector("#idtipodocumento");
    let iddoc = doc.value;
    // capturar tipo de documento
    
    doc.addEventListener('change', function(){
        iddoc = this.value;
        console.log(iddoc)
    })
    

    async function searchDoc() {
        const params = new URLSearchParams();
        params.append('idtipodocumento',iddoc)
        
    }
})