(function(_ds){var window=this;var LAa=function(a){const b=a.EN,c=a.We,d=a.YI;a=a.RK;let e;e='<ul class="devsite-nav-list"><li class="devsite-nav-item devsite-nav-heading devsite-toc-toggle"><span class="devsite-nav-title" role="heading" aria-level="2"><span class="devsite-nav-text">On this page</span></span>';c&&(e=e+'<button type="button" title="'+_ds.ny("Expand/collapse contents"),e+='" class="devsite-nav-show-all button-transparent material-icons"></button>');e+="</li>";const f=b.length;for(let h=0;h<f;h++){var g=b[h];e+='<li class="devsite-nav-item"'+
(c&&g.index<a?" visible":"")+'><a href="#'+_ds.V(g.id)+'" class="devsite-nav-title gc-analytics-event" data-category="Site-Wide Custom Events" data-action="click" data-label="'+(c?"Embedded nav":"Right nav")+'" data-value="'+_ds.V(h)+'" track-type="navigation" track-name="'+(c?"embeddedNav":"rightNav")+'" track-metadata-position="'+_ds.V(h)+'" track-metadata-link-destination="#'+_ds.V(g.id)+'"><span class="devsite-nav-text" tooltip>'+_ds.U(g.text)+"</span></a>";if(g.children.length){e+='<ul class="devsite-nav-list">';
g=g.children;const k=g.length;for(let l=0;l<k;l++){const m=g[l];e+='<li class="devsite-nav-item"'+(c&&m.index<a?" visible":"")+'><a href="#'+_ds.V(m.id)+'" class="devsite-nav-title gc-analytics-event" data-category="Site-Wide Custom Events" data-action="click" data-label="'+(c?"Embedded nav":"Right nav")+'" data-value="'+_ds.V(h)+"."+_ds.V(l)+'" track-type="navigation" track-name="'+(c?"embeddedNav":"rightNav")+'" track-metadata-position="'+_ds.V(h)+"."+_ds.V(l)+'" track-metadata-link-destination="#'+
_ds.V(m.id)+'"><span class="devsite-nav-text" tooltip>'+_ds.U(m.text)+"</span></a></li>"}e+="</ul>"}e+="</li>"}d&&(e=c?e+'<li class="devsite-nav-item devsite-apix-link"><a href="#try-it" class="devsite-nav-title"><span class="devsite-nav-text" tooltip>Try it</span></a></li>':e+'<button type="button" class="devsite-show-apix button-primary">Try it!</button>');c&&(e=e+'<li class="devsite-toc-toggle"><button type="button" class="button-flat devsite-nav-more-items material-icons" track-type="navigation" track-name="embeddedNavExpand" title="'+
_ds.ny("Expand/collapse contents"),e+='"></button></li>');return(0,_ds.T)(e+"</ul>")};var I8=function(a){if(!a.hasAttribute("disabled")){var b=document.querySelector("devsite-content .devsite-article-body");b?(a.We?a.classList.add("devsite-toc-embedded"):a.classList.add("devsite-toc"),MAa(a,b),a.ra=!0):a.bc()}},OAa=async function(a){await NAa(a);if(a.g){var b=`#${a.g.id}`,c=encodeURI(b);b=a.oa.get(b)||a.oa.get(c);a.j!==b&&(a.j&&a.j.classList.remove("devsite-nav-active"),b&&(b.classList.add("devsite-nav-active"),a.v&&("scrollIntoViewIfNeeded"in b?b.scrollIntoViewIfNeeded():b.scrollIntoView()),
a.j=b))}},PAa=function(a){a.We||a.eventHandler.listen(document.body,"devsite-content-updated devsite-element-hidden devsite-element-visible devsite-page-loaded devsite-sticky-resize devsite-sticky-scroll".split(" "),()=>{a.Da.fb()});a.eventHandler.listen(document.body,"devsite-content-updated",()=>{I8(a)})},QAa=async function(a){if("IntersectionObserver"in _ds.Bk()){a.pc&&a.pc.disconnect();var b=document.querySelector("devsite-header");let c=152;b&&(await customElements.whenDefined("devsite-header"),
(b=b.v+b.g)&&(c=b));a.pc=new IntersectionObserver(d=>{for(const e of d)e.isIntersecting?a.ea.add(e.target):a.ea.delete(e.target);a.Da.fb()},{rootMargin:`${c}px 0px 0px 0px`,threshold:[0,1]})}a.Ba.g()},NAa=async function(a){let b=0;var c=document.querySelector("devsite-header");c&&(await customElements.whenDefined("devsite-header"),b=_ds.WG(c));c=a.h.findIndex(e=>a.ea.has(e)&&e.getBoundingClientRect().top>=b);const d=a.h[c];if(d){const e=await RAa();d.getBoundingClientRect().top-b>e&&0<c?a.g=a.h[c-
1]:a.g=d}else a.g&&a.g.getBoundingClientRect().top>window.innerHeight&&(c=a.h.indexOf(a.g),0<c&&(a.g=a.h[c-1]))},MAa=function(a,b){const c=[];let d=!1,e="";switch(a.getAttribute("depth")){case "1":e="h2:not(.hide-from-toc):not(#contents):not(#table-of-contents)";break;default:e="h2:not(.hide-from-toc):not(#contents):not(#table-of-contents), h3:not(.hide-from-toc):not(#contents):not(#table-of-contents)"}a.h=[...b.querySelectorAll(e)].filter(f=>f.id&&f.dataset.text).filter(f=>SAa(f));for(const [f,g]of a.h.entries())b=
g,b={id:b.id,level:b.tagName.toLowerCase(),text:b.dataset.text,children:[],index:f},"h2"===b.level?(c.push(b),d=!0):d?c[c.length-1].children.push(b):c.push(b);_ds.yb(a.xa,c,a.ya.bind(a))&&a.ra||(c.length?(TAa(a,c),a.show(),a.We||UAa(a)):a.bc(),a.xa=c)},SAa=function(a){return _ds.ym.find(b=>!!_ds.el(a,null,b,6))||_ds.el(a,"devsite-selector",null,6)||_ds.el(a,null,"devsite-dialog",3)?!1:!0},TAa=function(a,b){const c=_ds.N(LAa,{EN:b,We:a.We,YI:!!document.body.querySelector("devsite-apix, .devsite-apix"),
RK:8>b.length?8:5});if(a.v)(b=c.querySelector("button.devsite-show-apix"))&&a.eventHandler.listen(b,"click",()=>{a.dispatchEvent(new CustomEvent("devsite-concierge-open-panel",{bubbles:!0,composed:!0,detail:{kx:"devsite-concierge-api-explorer-panel"}}))});else{b=document.querySelector("button.devsite-show-apix");const e=document.querySelector("devsite-apix");var d=!(null==e?0:e.querySelector("div.devsite-apix"));b&&e&&d&&a.eventHandler.listen(b,"click",()=>{e.scrollIntoView()})}b=c.querySelectorAll("a.devsite-nav-title");
for(const e of b){b=e;d=b.hash;const f=encodeURI(b.hash);a.oa.set(d,b);a.oa.set(f,b)}_ds.Gk(a);a.We&&_ds.Aj(a,"hidden","",c);a.appendChild(c);if(a.We){if(8<a.getElementsByClassName("devsite-nav-item").length){for(const e of a.querySelectorAll(".devsite-nav-show-all, .devsite-nav-more-items"))a.eventHandler.listen(e,"click",()=>{a.hasAttribute("expanded")?a.removeAttribute("expanded"):_ds.Aj(a,"expanded","")});_ds.Aj(a,"expandable","")}else a.removeAttribute("expandable");setTimeout(()=>{c.removeAttribute("hidden")},
0)}},UAa=async function(a){await a.Ba.promise;if(a.pc){a.pc.disconnect();a.ea.clear();a.j&&a.j.classList.remove("devsite-nav-active");a.j=null;for(const b of a.h)a.pc.observe(b)}},RAa=async function(){let a=0,b=0;const c=document.querySelector("devsite-header");c&&(await customElements.whenDefined("devsite-header"),a=_ds.WG(c),b=c.v+c.g);return Math.max(b-a,Math.floor((window.innerHeight-a)/5))},J8=class extends _ds.C{static get observedAttributes(){return["max-height","offset"]}constructor(){super();
this.eventHandler=new _ds.F;this.Ba=new _ds.yf;this.ea=new Set;this.oa=new Map;this.Fa=new _ds.xn(()=>void I8(this),16);this.Da=new _ds.xn(()=>void OAa(this),33);this.g=this.j=null;this.h=[];this.ra=!1;this.pc=null;this.v=this.We=!1;this.xa=[];_ds.zj(this,(0,_ds.q)`disabled`,(0,_ds.q)`has-sidebar`,(0,_ds.q)`hidden`,(0,_ds.q)`expandable`,(0,_ds.q)`expanded`,(0,_ds.q)`visible`)}connectedCallback(){this.We=this.hasAttribute("devsite-toc-embedded");this.v=document.body.hasAttribute("concierge");I8(this);
PAa(this)}disconnectedCallback(){this.bc();this.ra=!1;_ds.H(this.eventHandler)}vr(a){a=a&&"false"===a.toLowerCase();this.xa=[];_ds.Gk(this);a?(_ds.Aj(this,"disabled",""),this.bc()):(this.removeAttribute("disabled"),this.Fa.fb())}bc(){_ds.Gk(this);this.dispatchEvent(new CustomEvent("devsite-element-hidden",{bubbles:!0}));this.removeAttribute("visible");_ds.Aj(this,"hidden","");if(!this.We&&!this.v){const a=document.querySelector(".devsite-main-content");a&&a.removeAttribute("has-sidebar")}}show(){this.dispatchEvent(new CustomEvent("devsite-element-visible",
{bubbles:!0}));this.removeAttribute("hidden");_ds.Aj(this,"visible","");if(!this.We){if(!this.v){const a=document.querySelector(".devsite-main-content");a&&_ds.Aj(this,"has-sidebar","",a)}QAa(this)}}ya(a,b){let c=!0;if(a.children.length||b.children.length)c=_ds.yb(a.children,b.children,this.ya.bind(this));return c&&a.id===b.id&&a.text===b.text}};J8.prototype.renderUpdatedContent=J8.prototype.vr;J8.prototype.disconnectedCallback=J8.prototype.disconnectedCallback;J8.prototype.connectedCallback=J8.prototype.connectedCallback;try{customElements.define("devsite-toc",J8)}catch(a){console.warn("Unrecognized DevSite custom element - DevsiteToc",a)};})(_ds_www);
