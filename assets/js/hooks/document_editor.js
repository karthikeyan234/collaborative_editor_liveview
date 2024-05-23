let DocumentEditor = {
    mounted() {
      this.el.addEventListener("input", e => {
        this.pushEvent("update_content", { content: e.target.value });
      });
  
      this.handleEvent("content_update", ({ content }) => {
        this.el.value = content;
      });
    }
  };
  
  export default DocumentEditor;