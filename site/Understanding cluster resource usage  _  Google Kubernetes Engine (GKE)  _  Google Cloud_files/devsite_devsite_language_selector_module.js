(function(_ds){var window=this;var vwa=_ds.ww([":host{display:block;position:relative}*{-moz-box-sizing:border-box;box-sizing:border-box}[hidden]{display:none}button{-webkit-box-align:center;-moz-box-align:center;-ms-flex-align:center;-webkit-align-items:center;align-items:center;-moz-appearance:none;-webkit-appearance:none;background-color:var(--devsite-select-background-color,var(--devsite-background-1));border:var(--devsite-select-border,var(--devsite-secondary-border));border-radius:var(--devsite-select-border-radius);box-shadow:none;color:var(--devsite-select-color,var(--devsite-primary-text-color));cursor:pointer;display:-webkit-box;display:-webkit-flex;display:-moz-box;display:-ms-flexbox;display:flex;font:var(--devsite-select-font,500 14px/36px var(--devsite-primary-font-family));height:36px;max-width:154px;outline:0;padding-block:0;padding-inline:11px 7px;-webkit-transition:background-color .2s;transition:background-color .2s}button:is(:hover,:focus){background:var(--devsite-select-background-color-hover,var(--devsite-background-3))}.icon-arrow,.icon-language{block-size:24px;inline-size:24px;pointer-events:none}.icon-language{fill:var(--devsite-secondary-text-color);margin-inline:0 8px}.label{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}.icon-arrow{fill:var(--devsite-secondary-text-color)}[role=menu]{background:var(--devsite-background-1);border:var(--devsite-list-border,var(--devsite-secondary-border));border-radius:var(--devsite-list-border-radius,2px);box-shadow:0 1px 2px 0 var(--devsite-elevation-key-shadow-color),0 2px 6px 2px var(--devsite-elevation-ambient-shadow-color);inset-inline:var(--devsite-language-selector-menu-inset-inline,0 auto);max-height:304px;overflow:hidden auto;padding:8px 0;position:absolute;top:36px;-webkit-transform:var(--devsite-language-selector-menu-transform);transform:var(--devsite-language-selector-menu-transform);z-index:1}"]);var k6=function(a){a.links=[...a.querySelectorAll("a")];a.g=a.links.length-1;const b=_ds.D(),c=new URLSearchParams(b.search);c.delete("hl");for(const d of a.links){a=d.getAttribute("lang");const e=a.toLowerCase().replaceAll("_","-");_ds.Pe([(0,_ds.q)`lang`],d,"lang",e);"en"!==a&&c.set("hl",e);b.search=c.toString();_ds.Ce(d,_ds.we(b.href))}},wwa=async function(a){var b=await _ds.t();if(await b.getStorage().get("django_language","")){let c;if(b=null==(c=a.querySelector("[aria-current]"))?void 0:c.textContent)a.fd=
b}else await b.getStorage().set("django_language","",b.getLocale()||"en"),(a=a.querySelector('[lang="en"]'))&&_ds.Pe([(0,_ds.q)`aria-`],a,"aria-current","true")},l6=async function(){const a=await _ds.t(),b=await a.getStorage().get("django_language","");b&&await a.getStorage().set("language_preference","",b)},xwa=function(a){a.eventHandler.listen(document.body,"click",b=>{b.target!==a&&(a.open=!1,_ds.H(a.eventHandler))});a.eventHandler.listen(document.body,"keydown",b=>{"Escape"===b.key&&(a.open=!1,
_ds.H(a.eventHandler),a.toggle.focus())})},ywa=async function(a,b,c){a.dispatchEvent(new CustomEvent("devsite-analytics-observation",{detail:{category:"Site-Wide Custom Events",label:"Language Selector",action:`${b} to ${c}`},bubbles:!0}));b={eventData:JSON.stringify({name:"change",type:"languageSelector",metadata:{"selected-language":`${c}`,"original-language":`${b}`}})};a.dispatchEvent(new CustomEvent("devsite-analytics-observation-cloudtrack",{detail:b,bubbles:!0}))},zwa=async function(a,b){const c=
b.target.getAttribute("lang");c&&(b.stopPropagation(),await (await _ds.t()).getStorage().set("django_language","",c),(b=document.documentElement.getAttribute("lang"))&&await ywa(a,b,c),await l6(),a=new URL(_ds.Bk().location.toString()),a.searchParams.delete("hl"),_ds.af(_ds.Bk().location,_ds.we(a.toString())))},m6=class extends _ds.Zw{constructor(){super(...arguments);this.eventHandler=new _ds.F;this.links=[];this.g=0;this.ariaLabel="Select your language preference.";this.open=!1;this.fd="Language"}static get styles(){return vwa}async eb(){k6(this);
try{await wwa(this),await l6()}catch(a){}}async h(){if(this.open=!this.open){await this.Wa;let a;null==(a=this.querySelector("[aria-current]"))||a.focus();xwa(this)}else _ds.H(this.eventHandler)}render(){return(0,_ds.S)` <button
        type="button"
        aria-controls="language-menu"
        aria-haspopup="true"
        @click="${this.h}">
        <svg
          aria-hidden="true"
          class="icon-language"
          viewbox="0 0 24 24"
          xmlns="http://www.w3.org/2000/svg">
          <path
            d="M12 22q-2.05 0-3.875-.788-1.825-.787-3.187-2.15-1.363-1.362-2.15-3.187Q2 14.05 2 12q0-2.075.788-3.887.787-1.813 2.15-3.175Q6.3 3.575 8.125 2.787 9.95 2 12 2q2.075 0 3.887.787 1.813.788 3.175 2.151 1.363 1.362 2.15 3.175Q22 9.925 22 12q0 2.05-.788 3.875-.787 1.825-2.15 3.187-1.362 1.363-3.175 2.15Q14.075 22 12 22Zm0-2.05q.65-.9 1.125-1.875T13.9 16h-3.8q.3 1.1.775 2.075.475.975 1.125 1.875Zm-2.6-.4q-.45-.825-.787-1.713Q8.275 16.95 8.05 16H5.1q.725 1.25 1.812 2.175Q8 19.1 9.4 19.55Zm5.2 0q1.4-.45 2.487-1.375Q18.175 17.25 18.9 16h-2.95q-.225.95-.562 1.837-.338.888-.788 1.713ZM4.25 14h3.4q-.075-.5-.113-.988Q7.5 12.525 7.5 12t.037-1.012q.038-.488.113-.988h-3.4q-.125.5-.188.988Q4 11.475 4 12t.062 1.012q.063.488.188.988Zm5.4 0h4.7q.075-.5.113-.988.037-.487.037-1.012t-.037-1.012q-.038-.488-.113-.988h-4.7q-.075.5-.112.988Q9.5 11.475 9.5 12t.038 1.012q.037.488.112.988Zm6.7 0h3.4q.125-.5.188-.988Q20 12.525 20 12t-.062-1.012q-.063-.488-.188-.988h-3.4q.075.5.112.988.038.487.038 1.012t-.038 1.012q-.037.488-.112.988Zm-.4-6h2.95q-.725-1.25-1.813-2.175Q16 4.9 14.6 4.45q.45.825.788 1.712.337.888.562 1.838ZM10.1 8h3.8q-.3-1.1-.775-2.075Q12.65 4.95 12 4.05q-.65.9-1.125 1.875T10.1 8Zm-5 0h2.95q.225-.95.563-1.838.337-.887.787-1.712Q8 4.9 6.912 5.825 5.825 6.75 5.1 8Z" />
        </svg>
        <span class="label">${this.fd}</span>
        <svg
          aria-hidden="true"
          class="icon-arrow"
          viewbox="0 0 24 24"
          xmlns="http://www.w3.org/2000/svg">
          <path d="m12 15-5-5h10Z" />
        </svg>
      </button>
      <div
        id="language-menu"
        role="menu"
        @click="${a=>void zwa(this,a)}"
        @keydown="${a=>{if("ArrowUp"===a.key||"ArrowDown"===a.key){a.preventDefault();let b=0;const c=document.activeElement;c&&(b=this.links.indexOf(c));b="ArrowUp"===a.key?0===b?this.g:b-1:b===this.g?0:b+1;this.links[b].focus()}}}"
        ?hidden=${!this.open}>
        <slot></slot>
      </div>`}Ac(a){if(a&&(a=a.querySelector("ul"))){let b;null==(b=this.querySelector("ul"))||b.remove();this.append(a);k6(this);_ds.Pw(this)}}};_ds.v([_ds.I({type:String,Ca:"aria-label",Ma:!0}),_ds.w("design:type",Object)],m6.prototype,"ariaLabel",void 0);_ds.v([_ds.I({type:Boolean,Ma:!0}),_ds.w("design:type",Object)],m6.prototype,"open",void 0);_ds.v([_ds.J(),_ds.w("design:type",Object)],m6.prototype,"fd",void 0);
_ds.v([_ds.yq("button"),_ds.w("design:type",HTMLButtonElement)],m6.prototype,"toggle",void 0);try{customElements.define("devsite-language-selector",m6)}catch(a){console.warn("devsite.app.customElement.DevsiteLanguageSelector",a)};})(_ds_www);
