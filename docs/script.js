/* ============================================================
   Data Engineering Toolkit — script.js
   - Loads docs/tools.json and renders the master tool index
   - Search + status filtering
   - Documentation list
   - Nav (mobile toggle, active link), smooth scroll, reveal animations
   - Copy-to-clipboard
   Works both on GitHub Pages (fetch) and when opened via file:// (embedded fallback).
   ============================================================ */

(function () {
  "use strict";

  /* ---------- Inline SVG icon set (stroke-based, 24x24) ---------- */
  const ICONS = {
    export: '<svg viewBox="0 0 24 24"><path d="M12 3v12"/><path d="m7 10 5 5 5-5"/><path d="M5 21h14"/></svg>',
    code:   '<svg viewBox="0 0 24 24"><path d="m8 8-4 4 4 4"/><path d="m16 8 4 4-4 4"/><path d="m14 4-4 16"/></svg>',
    play:   '<svg viewBox="0 0 24 24"><path d="M6 4v16l14-8z"/></svg>',
    sync:   '<svg viewBox="0 0 24 24"><path d="M21 12a9 9 0 0 1-15.5 6.2L3 16"/><path d="M3 12a9 9 0 0 1 15.5-6.2L21 8"/><path d="M3 21v-5h5"/><path d="M21 3v5h-5"/></svg>',
    tools:  '<svg viewBox="0 0 24 24"><path d="M14.7 6.3a4 4 0 0 0 5 5L22 9l-3 3-4-4 3-3-2.3 1.3Z"/><path d="m3 21 9.5-9.5"/><path d="M6 18 3 21"/><path d="M10 7 7 10 3 6l3-3z"/></svg>',
    book:   '<svg viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>',
    github: '<svg viewBox="0 0 24 24"><path d="M12 .5C5.7.5.5 5.7.5 12c0 5.1 3.3 9.4 7.9 10.9.6.1.8-.3.8-.6v-2c-3.2.7-3.9-1.5-3.9-1.5-.5-1.3-1.3-1.7-1.3-1.7-1-.7.1-.7.1-.7 1.2.1 1.8 1.2 1.8 1.2 1 1.8 2.7 1.3 3.4 1 .1-.8.4-1.3.7-1.6-2.6-.3-5.3-1.3-5.3-5.7 0-1.3.5-2.3 1.2-3.1-.1-.3-.5-1.5.1-3.1 0 0 1-.3 3.2 1.2a11 11 0 0 1 5.8 0c2.2-1.5 3.2-1.2 3.2-1.2.6 1.6.2 2.8.1 3.1.8.8 1.2 1.8 1.2 3.1 0 4.4-2.7 5.4-5.3 5.7.4.4.8 1.1.8 2.2v3.3c0 .3.2.7.8.6 4.6-1.5 7.9-5.8 7.9-10.9C23.5 5.7 18.3.5 12 .5z"/></svg>',
  };

  /* ---------- Embedded fallback manifest (used when fetch is blocked, e.g. file://) ---------- */
  const FALLBACK = {
    site: { repo: "https://github.com/rakeshgniq/data-engineering-toolkit",
            installBase: "https://raw.githubusercontent.com/rakeshgniq/data-engineering-toolkit/main/install.sh" },
    categories: [{ id: "singlestore", name: "SingleStore", blurb: "" }],
    tools: [{ id: "singlestore-pipeline-sync", name: "Pipeline Export & Sync", category: "singlestore", icon: "export",
              status: "stable", summary: "Export pipelines to SQL and re-apply them.", tags: ["singlestore"],
              page: "tools/singlestore-pipeline-sync.html", repoPath: "tools/singlestore-pipeline-sync", install: true }],
    docs: []
  };

  const $ = (s, r = document) => r.querySelector(s);
  const $$ = (s, r = document) => Array.from(r.querySelectorAll(s));
  const esc = (s) => String(s ?? "").replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));

  let manifest = null;
  let state = { q: "", status: "all" };

  /* ---------- Static icons on the page ---------- */
  function paintStaticIcons() {
    $$("[data-icon]").forEach((el) => { el.innerHTML = ICONS[el.dataset.icon] || ""; });
  }

  /* ---------- Load manifest ---------- */
  async function loadManifest() {
    try {
      const res = await fetch("tools.json", { cache: "no-store" });
      if (!res.ok) throw new Error(res.status);
      return await res.json();
    } catch (e) {
      console.warn("tools.json unavailable, using embedded fallback:", e.message);
      return FALLBACK;
    }
  }

  /* ---------- Render helpers ---------- */
  function toolCard(t, site) {
    const planned = t.status === "planned";
    const installCmd = t.install ? `curl -sL ${site.installBase} | bash -s ${t.id}` : null;
    const actions = [];
    if (t.page) actions.push(`<a class="btn btn--primary btn--sm" href="${esc(t.page)}">Open</a>`);
    if (t.repoPath) actions.push(`<a class="btn btn--ghost btn--sm" href="${esc(site.repo)}/tree/main/${esc(t.repoPath)}" target="_blank" rel="noopener">Source</a>`);
    if (installCmd) actions.push(`<button class="btn btn--ghost btn--sm copy" data-text="${esc(installCmd)}">Copy install</button>`);
    if (!actions.length) actions.push(`<span class="muted" style="font-size:.9rem">Coming soon</span>`);

    return `
      <article class="card tool reveal ${planned ? "tool--planned" : ""}" data-id="${esc(t.id)}">
        <div class="tool__top">
          <div class="card__icon">${ICONS[t.icon] || ICONS.tools}</div>
          <span class="badge badge--${esc(t.status)}">${esc(t.status)}</span>
        </div>
        <h3>${esc(t.name)}</h3>
        <p>${esc(t.summary)}</p>
        <div class="tool__tags">${(t.tags || []).map((x) => `<span>${esc(x)}</span>`).join("")}</div>
        <div class="tool__actions">${actions.join("")}</div>
      </article>`;
  }

  function matches(t) {
    if (state.status !== "all" && t.status !== state.status) return false;
    if (!state.q) return true;
    const hay = [t.name, t.summary, t.id, ...(t.tags || [])].join(" ").toLowerCase();
    return hay.includes(state.q);
  }

  function renderIndex() {
    const root = $("#toolIndex");
    if (!root || !manifest) return;
    const { categories, tools, site } = manifest;
    const visible = tools.filter(matches);

    if (!visible.length) {
      root.innerHTML = `<div class="empty">No tools match “${esc(state.q)}”.</div>`;
      return;
    }

    root.innerHTML = categories
      .map((c) => {
        const items = visible.filter((t) => t.category === c.id);
        if (!items.length) return "";
        return `
          <section class="tool-category">
            <div class="tool-category__head">
              <h3>${esc(c.name)}</h3><span>${esc(c.blurb || "")}</span>
            </div>
            <div class="grid grid--3">${items.map((t) => toolCard(t, site)).join("")}</div>
          </section>`;
      })
      .join("");

    // Tools whose category isn't declared still show up (future-proofing)
    const known = new Set(categories.map((c) => c.id));
    const orphans = visible.filter((t) => !known.has(t.category));
    if (orphans.length) {
      root.insertAdjacentHTML("beforeend", `
        <section class="tool-category">
          <div class="tool-category__head"><h3>Other</h3></div>
          <div class="grid grid--3">${orphans.map((t) => toolCard(t, site)).join("")}</div>
        </section>`);
    }

    observeReveal();
  }

  function renderStats() {
    const t = manifest.tools;
    const set = (k, v) => { const el = $(`[data-stat="${k}"]`); if (el) el.textContent = v; };
    set("tools", t.length);
    set("stable", t.filter((x) => x.status === "stable").length);
    set("categories", manifest.categories.length);
  }

  function renderDocs() {
    const ul = $("#docList");
    if (!ul) return;
    const docs = manifest.docs || [];
    ul.innerHTML = docs.length
      ? docs.map((d) => `
          <li><a href="${esc(d.href)}" ${/^https?:/.test(d.href) ? 'target="_blank" rel="noopener"' : ""}>
            <div><strong>${esc(d.title)}</strong><small>${esc(d.note || "")}</small></div>
            <span class="arrow">→</span></a></li>`).join("")
      : `<li class="muted">Documentation pages coming soon.</li>`;
  }

  function renderRepo() {
    const s = manifest.site || {};
    const link = $("#repoLink"); if (link && s.repo) link.href = s.repo;
    const cmd = $("#installCmd"); if (cmd && s.installBase) cmd.textContent = `curl -sL ${s.installBase} | bash -s <tool-name>`;
  }

  /* ---------- Search / filter ---------- */
  function bindToolbar() {
    const q = $("#toolSearch");
    if (q) q.addEventListener("input", () => { state.q = q.value.trim().toLowerCase(); renderIndex(); });
    $$("#statusChips .chip").forEach((chip) =>
      chip.addEventListener("click", () => {
        $$("#statusChips .chip").forEach((c) => c.classList.remove("chip--active"));
        chip.classList.add("chip--active");
        state.status = chip.dataset.status;
        renderIndex();
      })
    );
  }

  /* ---------- Copy to clipboard (delegated) ---------- */
  document.addEventListener("click", async (e) => {
    const btn = e.target.closest(".copy");
    if (!btn) return;
    const text = btn.dataset.text ?? (btn.dataset.copy ? $(btn.dataset.copy)?.textContent : btn.closest("pre")?.querySelector("code")?.textContent);
    if (!text) return;
    try {
      await navigator.clipboard.writeText(text.trim());
      const old = btn.textContent; btn.textContent = "Copied ✓"; btn.classList.add("copied");
      setTimeout(() => { btn.textContent = old; btn.classList.remove("copied"); }, 1600);
    } catch { alert("Copy failed — select the text manually."); }
  });

  /* ---------- Navigation ---------- */
  function bindNav() {
    const toggle = $("#navToggle"), links = $("#navLinks");
    if (toggle && links) {
      toggle.addEventListener("click", () => {
        const open = links.classList.toggle("open");
        toggle.setAttribute("aria-expanded", String(open));
      });
      $$("a", links).forEach((a) => a.addEventListener("click", () => { links.classList.remove("open"); toggle.setAttribute("aria-expanded", "false"); }));
    }
    // Active link highlight on scroll
    const sections = $$("section[id]");
    const navAnchors = $$("#navLinks a");
    if (sections.length && "IntersectionObserver" in window) {
      const io = new IntersectionObserver((entries) => {
        entries.forEach((en) => {
          if (!en.isIntersecting) return;
          navAnchors.forEach((a) => a.classList.toggle("active", a.getAttribute("href") === `#${en.target.id}`));
        });
      }, { rootMargin: "-45% 0px -50% 0px" });
      sections.forEach((s) => io.observe(s));
    }
  }

  /* ---------- Reveal on scroll ---------- */
  let revealObserver = null;
  function observeReveal() {
    if (!("IntersectionObserver" in window)) { $$(".reveal").forEach((el) => el.classList.add("in")); return; }
    revealObserver ??= new IntersectionObserver((entries) => {
      entries.forEach((en) => { if (en.isIntersecting) { en.target.classList.add("in"); revealObserver.unobserve(en.target); } });
    }, { threshold: 0.12 });
    $$(".reveal:not(.in)").forEach((el) => revealObserver.observe(el));
  }

  /* ---------- Boot ---------- */
  async function init() {
    paintStaticIcons();
    bindNav();
    observeReveal();
    const y = $("#year"); if (y) y.textContent = new Date().getFullYear();

    // Only the master index page has #toolIndex
    if ($("#toolIndex")) {
      manifest = await loadManifest();
      renderStats(); renderIndex(); renderDocs(); renderRepo(); bindToolbar();
    }
  }

  document.addEventListener("DOMContentLoaded", init);
})();

