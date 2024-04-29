(function(_ds){var window=this;var ika=async function(){const a=(await _ds.t()).getStaticPath(!0);return(0,_ds.S)`<img src="${a}/images/cloud-shell-cta-art.png" />`};var jka=async function(){return await (await _ds.t()).getStorage().get("cloudshell","hide_fte_banner")},EU=class extends _ds.Zw{constructor(){super(...arguments);this.isDogfood=this.isResizing=!1;this.offset=0;this.YC="";this.cloudtrack=new _ds.WA;this.sj=a=>{this.ax(a)};this.uj=()=>{this.bx()};this.wL=()=>{document.body.setAttribute("no-scroll","")};this.vL=()=>{document.body.hasAttribute("no-scroll")&&document.body.removeAttribute("no-scroll")}}ax(a){this.isResizing&&this.Lg&&(a=Math.floor(this.Lg.bottom-
a.clientY+this.offset).toString(),this.resizer.setAttribute("aria-valuenow",a),this.style.height=a+"px")}bx(){this.isResizing=!1;window.removeEventListener("pointermove",this.sj);window.removeEventListener("pointerup",this.uj);this.style.pointerEvents="auto";this.Qg("pane_resize",{GZ:!0})}Ua(){return this}render(){this.isDogfood||this.setAttribute("height-visual-offset","24");return(0,_ds.S)`
    <div
      class="resizer"
      role="separator"
      aria-valuemin="0"
      aria-valuemax="0"
      @pointerdown="${this.ex}">
      ${this.isDogfood?(0,_ds.S)` <div class="dogfood-notice">
    <a href="http://goto.google.com/cgc-cloud-shell-known-issues">
      <span class="material-icons">pets</span>
      <span class="notice-text">Dogfood Version - Internal Only</span>
    </a>
  </div>`:""}
      <div class="grabber-focus">
        <div class="grabber"></div>
      </div>
    </div>
    <devsite-shell
      @pointerover="${this.wL}"
      @pointerout="${this.vL}"
      @devsite-shell-opened="${this.EL}"
      @devsite-shell-closed="${this.yL}"
      @devsite-shell-resized="${this.HL}"
      @devsite-shell-maximized="${this.zL}">
    </devsite-shell>
    ${(0,_ds.S)` <div class="free-trial-banner">
    <a
      @click="${this.oL}"
      class="close-btn button-white material-icons"
      aria-label="${"Close Cloud Shell"}"
      >close</a
    >
    <div class="banner-text">
      <h3>${"Welcome to Cloud Shell"}</h3>
      <p>${"Cloud Shell is a development environment that you can use in the browser:"}</p>
      <ul>
        <li>${"Activate Cloud Shell to explore Google Cloud with a terminal and an editor"}</li>
        <li>${"Start a free trial to get $300 in free credits"}</li>
      </ul>
      <div class="row">
        <button
          @click="${this.kL}"
          class="button-blue"
          >${"Activate Cloud Shell"}
        </button>
        <button @click="${this.gx}">
          ${"Start a free trial"}</button
        >
      </div>
    </div>
    ${(0,_ds.NG)(ika(),"")}
  </div>`}
  `}HL(a){if(null==a?0:a.detail)a=(a.detail.WK+this.resizer.offsetHeight).toString(),this.resizer.setAttribute("aria-valuenow",a),this.style.height=a+"px",this.removeAttribute("devsite-size"),this.Ir.isMaximized=!1,this.Qg("pane_resize",{isManual:!1})}async EL(){"true"===await jka()&&this.removeAttribute("enable-fte-user-flow");this.classList.add("opened");this.Qg("pane_open")}yL(){this.classList.remove("opened");this.Qg("pane_close");this.hasAttribute("devsite-size")&&(this.removeAttribute("devsite-size"),
this.Ir.isMaximized=!1,this.style.height=this.YC);document.body.hasAttribute("no-scroll")&&document.body.removeAttribute("no-scroll")}zL(){_ds.Ta()&&this.setAttribute("cr-os","");this.YC=this.style.height;this.setAttribute("devsite-size","content-area");this.style.height="100%"}ex(a){this.isResizing=!0;this.Lg=this.getBoundingClientRect();window.addEventListener("pointermove",this.sj);window.addEventListener("pointerup",this.uj);this.offset=a.offsetY;this.style.pointerEvents="none"}Qg(a,b){this.cloudtrack.g({type:"cloudShell",
name:a.toString(),metadata:b})}oL(){if(this.Ir){var a=this.Ir;a.g.isOpen&&a.g.close()}}kL(){this.lA&&this.lA.classList.add("hidden")}gx(){this.Qg("pane_free_trial_click");const a=new URL("https://console.cloud.google.com/freetrial");a.searchParams.set("redirectPath",window.location.href);a.searchParams.set("utm_source","ext");a.searchParams.set("utm_medium","partner");a.searchParams.set("utm_campaign","CDR_cma_gcp_cloudshell_freetrial_020222");a.searchParams.set("utm_content","-");_ds.$e(window.location,
_ds.we(a.toString()))}};_ds.v([_ds.yq(".free-trial-banner"),_ds.w("design:type",HTMLElement)],EU.prototype,"lA",void 0);_ds.v([_ds.yq(".resizer"),_ds.w("design:type",HTMLElement)],EU.prototype,"resizer",void 0);_ds.v([_ds.yq("devsite-shell"),_ds.w("design:type",_ds.CG)],EU.prototype,"Ir",void 0);_ds.v([_ds.I({Ca:"is-resizing",Ma:!0,type:Boolean}),_ds.w("design:type",Object)],EU.prototype,"isResizing",void 0);
_ds.v([_ds.I({Ca:"cloudshell-dogfood",type:Boolean}),_ds.w("design:type",Object)],EU.prototype,"isDogfood",void 0);try{customElements.define("cloud-shell-pane",EU)}catch(a){console.warn("Unrecognized DevSite custom element - CloudShellPane",a)};})(_ds_www);
