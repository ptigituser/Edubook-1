@extends('portal.layout')
@section('title', 'داشبۆرد — EduBook - IQ')
@section('styles')
<style>
/* ════════════════════════════════════════════════
   TOKENS – Premium Dark Gold
════════════════════════════════════════════════ */
:root {
  --gold:    #e2b042;
  --gold-lt: #fbbf24;
  --gold-dk: #b88728;
  --bg:      #060a12;
  --bg2:     #0c1220;
  --bg3:     #151e30;
  --bg4:     #1e2d46;
  --border:  rgba(226, 176, 66, 0.10);
  --border2: rgba(226, 176, 66, 0.24);
  --txt:     #f1f5f9;
  --txt2:    #8b9ec2;
  --txt3:    #556680;
  --red:     #ef4444;
  --green:   #10b981;
  --grad:    linear-gradient(135deg, #b88728, #fbbf24);
  --grad2:   linear-gradient(135deg, #1a1040, #0c1220, #0a1628);
  --glass:   rgba(12, 18, 32, 0.65);
  --glass2:  rgba(20, 30, 50, 0.45);
  --radius:  18px;
  --radius-sm: 12px;
  --ease:    cubic-bezier(0.4, 0, 0.2, 1);
}

/* ════════════════════════════════════════════════
   LAYOUT
════════════════════════════════════════════════ */
*, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }

.db {
  display: flex;
  min-height: calc(100vh - 66px);
  background: var(--bg);
  direction: rtl;
  position: relative;
  overflow: hidden;
}
.db::before, .db::after {
  content: '';
  position: absolute;
  border-radius: 50%;
  filter: blur(120px);
  z-index: 0;
  pointer-events: none;
  animation: floatOrb 15s ease-in-out infinite alternate;
}
.db::before {
  width: 600px; height: 600px;
  background: rgba(226, 176, 66, 0.08);
  top: -200px; left: -100px;
}
.db::after {
  width: 500px; height: 500px;
  background: rgba(16, 185, 129, 0.03);
  bottom: -150px; right: -100px;
  animation-delay: -5s;
}
@keyframes floatOrb {
  0% { transform: translate(0, 0) scale(1); }
  100% { transform: translate(100px, 50px) scale(1.15); }
}
.db-side, .db-main { position: relative; z-index: 1; }

/* ════════════════════════════════════════════════
   SIDEBAR
════════════════════════════════════════════════ */
.db-side {
  width: 240px;
  flex-shrink: 0;
  background: var(--bg2);
  border-left: 1px solid var(--border);
  display: flex;
  flex-direction: column;
  position: sticky;
  top: 66px;
  height: calc(100vh - 66px);
  overflow-y: auto;
  padding: 1.25rem .85rem 1rem;
}

.db-avatar {
  display: flex;
  align-items: center;
  gap: .75rem;
  padding: .75rem .5rem 1.25rem;
  border-bottom: 1px solid var(--border);
  margin-bottom: 1.1rem;
}
.db-avatar-circle {
  width: 42px; height: 42px;
  border-radius: 12px;
  background: var(--grad);
  box-shadow: 0 4px 18px rgba(226, 176, 66, 0.30);
  display: flex; align-items: center; justify-content: center;
  font-size: 1rem; font-weight: 900; color: #080c14;
  flex-shrink: 0;
  position: relative;
}
.db-avatar-circle::after {
  content: '';
  position: absolute; inset: -2px;
  border-radius: 14px;
  border: 1.5px solid rgba(226,176,66,.25);
  pointer-events: none;
}
.db-avatar-name  { font-size: .87rem; font-weight: 700; color: var(--txt); line-height: 1.3; }
.db-avatar-email { font-size: .71rem; color: var(--txt3); margin-top: 1px; word-break: break-all; }

.db-nav { display: flex; flex-direction: column; gap: 4px; }
.db-nav-btn {
  display: flex; align-items: center; gap: 10px;
  padding: 11px 14px;
  border-radius: 12px; border: none;
  background: transparent;
  color: var(--txt2);
  font-family: inherit; font-size: .87rem; font-weight: 700;
  cursor: pointer; width: 100%; text-align: right;
  transition: all .2s var(--ease);
  position: relative;
}
.db-nav-btn:hover { background: rgba(226, 176, 66, 0.07); color: var(--gold-lt); }
.db-nav-btn.is-active {
  background: rgba(226, 176, 66, 0.10);
  color: var(--gold-lt);
  box-shadow: inset 0 0 0 1px rgba(226,176,66,.12);
}
.db-nav-btn.is-active::before {
  content: '';
  position: absolute; right: 0; top: 18%; height: 64%; width: 3px;
  background: var(--grad);
  border-radius: 2px 0 0 2px;
  box-shadow: 0 0 8px rgba(226,176,66,.35);
}
.db-nav-icon { font-size: 1.05rem; flex-shrink: 0; }
.db-nav-badge {
  margin-right: auto;
  background: rgba(226, 176, 66, 0.16);
  color: var(--gold-lt);
  font-size: .65rem; padding: 2px 8px;
  border-radius: 20px; font-weight: 800;
}
.db-sep { height: 1px; background: var(--border); margin: .75rem 0; }

.db-logout-btn {
  display: flex; align-items: center; gap: 10px;
  padding: 10px 14px; border-radius: 12px; border: none;
  background: transparent; color: var(--txt3);
  font-family: inherit; font-size: .84rem; font-weight: 700;
  cursor: pointer; width: 100%; margin-top: auto;
  transition: all .2s var(--ease);
}
.db-logout-btn:hover { background: rgba(255,69,69,.08); color: #ff8080; }

/* ════════════════════════════════════════════════
   MAIN
════════════════════════════════════════════════ */
.db-main {
  flex: 1;
  padding: 2.5rem 3rem 5rem;
  max-width: 980px;
  overflow-y: auto;
}

.db-tab { display: none; animation: dbFade .35s var(--ease); }
.db-tab.is-active { display: block; }
@keyframes dbFade { from { opacity:0; transform:translateY(12px) } to { opacity:1; transform:none } }

/* ── Page header ── */
.pg-head { margin-bottom: 2.25rem; position: relative; }
.pg-title {
  font-size: 2.2rem; font-weight: 900;
  color: var(--txt); letter-spacing: -.03em;
  line-height: 1.2;
}
.pg-title span {
  background: linear-gradient(to right, var(--gold-lt), var(--gold), #ff9d00, var(--gold-lt));
  background-size: 200% auto;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: shineText 4s linear infinite;
}
@keyframes shineText {
  to { background-position: 200% center; }
}
.pg-sub {
  font-size: .86rem; color: var(--txt2); margin-top: .5rem;
  opacity: .85;
}

.pg-head-row {
  display: flex; align-items: flex-end;
  justify-content: space-between;
  flex-wrap: wrap; gap: 1rem;
  margin-bottom: 1.75rem;
}

/* ── Notice ── */
.nt {
  display: flex; align-items: flex-start; gap: 14px;
  padding: 1.1rem 1.35rem; border-radius: 14px;
  margin-bottom: 1.5rem; font-size: .86rem; font-weight: 600;
  line-height: 1.55;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}
.nt-warn {
  background: rgba(251,191,36,.05);
  border: 1px solid rgba(251,191,36,.18);
  color: #fbbf24;
  box-shadow: 0 0 20px rgba(251,191,36,.04);
}
.nt-ok {
  background: rgba(34,197,94,.05);
  border: 1px solid rgba(34,197,94,.18);
  color: #4ade80;
  box-shadow: 0 0 20px rgba(34,197,94,.04);
}
.nt-icon { font-size: 1.1rem; flex-shrink: 0; }
.nt-title { font-weight: 800; font-size: .88rem; }
.nt-sub   { font-size: .78rem; opacity: .7; margin-top: 2px; }

/* ════════════════════════════════════════════════
   STATS GRID & RATING STYLES
════════════════════════════════════════════════ */
.db-stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1.25rem;
  margin-bottom: 2rem;
}
.db-stat-box {
  background: rgba(12, 18, 32, 0.55);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(226, 176, 66, 0.12);
  border-radius: var(--radius);
  padding: 1.25rem 1.4rem;
  display: flex;
  align-items: center;
  gap: 1.1rem;
  position: relative;
  overflow: hidden;
  transition: all .3s var(--ease);
}
.db-stat-box:hover {
  transform: translateY(-3px);
  border-color: rgba(226, 176, 66, 0.3);
  box-shadow: 0 12px 30px rgba(0,0,0,0.3);
}
.db-stat-icon-wrap {
  width: 50px; height: 50px;
  border-radius: 14px;
  display: flex; align-items: center; justify-content: center;
  font-size: 1.4rem;
  flex-shrink: 0;
}
.db-stat-icon-wrap.gold {
  background: rgba(251, 191, 36, 0.12);
  color: #fbbf24;
  border: 1px solid rgba(251, 191, 36, 0.25);
}
.db-stat-icon-wrap.green {
  background: rgba(16, 185, 129, 0.12);
  color: #34d399;
  border: 1px solid rgba(16, 185, 129, 0.25);
}
.db-stat-icon-wrap.amber {
  background: rgba(245, 158, 11, 0.12);
  color: #fbbf24;
  border: 1px solid rgba(245, 158, 11, 0.25);
}
.db-stat-icon-wrap.blue {
  background: rgba(59, 130, 246, 0.12);
  color: #60a5fa;
  border: 1px solid rgba(59, 130, 246, 0.25);
}
.db-stat-title {
  font-size: .78rem;
  font-weight: 700;
  color: var(--txt2);
  margin-bottom: 4px;
}
.db-stat-val {
  font-size: 1.35rem;
  font-weight: 900;
  color: var(--txt);
  display: flex;
  align-items: baseline;
  gap: 4px;
}
.db-stat-sub {
  font-size: .75rem;
  color: var(--txt3);
  font-weight: 600;
}
.db-stat-hint {
  font-size: .72rem;
  color: var(--gold-lt);
  margin-top: 3px;
  font-weight: 600;
}

/* ════════ REVIEWS SECTION STYLES ════════ */
.review-overview-card {
  display: grid;
  grid-template-columns: 240px 1fr;
  gap: 2rem;
  align-items: center;
  padding: 2rem;
  background: rgba(15, 23, 42, 0.55);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(226, 176, 66, 0.16);
  border-radius: var(--radius);
  margin-bottom: 2rem;
}
@media (max-width: 768px) {
  .review-overview-card {
    grid-template-columns: 1fr;
    text-align: center;
  }
}
.review-score-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 1.5rem;
  background: rgba(226, 176, 66, 0.05);
  border: 1px solid rgba(226, 176, 66, 0.18);
  border-radius: 16px;
}
.review-big-score {
  font-size: 3.4rem;
  font-weight: 900;
  color: #fbbf24;
  line-height: 1;
  text-shadow: 0 4px 18px rgba(251, 191, 36, 0.3);
}
.review-stars-row {
  display: flex;
  gap: 3px;
  color: #fbbf24;
  font-size: 1.3rem;
  margin: 8px 0;
}
.review-score-count {
  font-size: .82rem;
  color: var(--txt2);
  font-weight: 600;
}
.rating-dist-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.rating-dist-item {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: .84rem;
  color: var(--txt2);
}
.rating-dist-bar {
  flex: 1;
  height: 8px;
  background: rgba(255, 255, 255, 0.08);
  border-radius: 6px;
  overflow: hidden;
}
.rating-dist-fill {
  height: 100%;
  background: linear-gradient(90deg, #b88728, #fbbf24);
  border-radius: 6px;
  transition: width .5s ease;
}
.rating-dist-num {
  min-width: 50px;
  text-align: left;
  font-weight: 700;
  color: var(--txt);
  font-size: .78rem;
  direction: ltr;
}

/* Individual Review Cards */
.review-item-card {
  background: rgba(12, 18, 32, 0.45);
  backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.04);
  border-radius: 16px;
  padding: 1.35rem 1.5rem;
  margin-bottom: 1.1rem;
  transition: all .25s var(--ease);
}
.review-item-card:hover {
  border-color: rgba(226, 176, 66, 0.2);
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.25);
}
.review-item-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: .85rem;
}
.review-user-info {
  display: flex;
  align-items: center;
  gap: 12px;
}
.review-user-avatar {
  width: 40px; height: 40px;
  border-radius: 12px;
  background: var(--grad);
  color: #060a12;
  font-weight: 800;
  display: flex; align-items: center; justify-content: center;
  font-size: 1rem;
  overflow: hidden;
}
.review-user-avatar img {
  width: 100%; height: 100%; object-fit: cover;
}
.review-user-name {
  font-weight: 700;
  color: var(--txt);
  font-size: .92rem;
}
.review-date {
  font-size: .74rem;
  color: var(--txt3);
}
.review-stars {
  color: #fbbf24;
  font-size: 1.1rem;
  letter-spacing: 2px;
}
.review-comment {
  font-size: .88rem;
  line-height: 1.6;
  color: var(--txt2);
  background: rgba(255, 255, 255, 0.02);
  padding: .85rem 1.1rem;
  border-radius: 10px;
  border-right: 3px solid rgba(226, 176, 66, 0.5);
}

/* ════════ CHAT / MESSAGES SECTION STYLES ════════ */
.chat-container {
  display: grid;
  grid-template-columns: 320px 1fr;
  background: rgba(12, 18, 32, 0.55);
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
  border: 1px solid rgba(226, 176, 66, 0.16);
  border-radius: var(--radius);
  height: 650px;
  overflow: hidden;
  box-shadow: 0 16px 40px rgba(0,0,0,0.35);
}
@media (max-width: 860px) {
  .chat-container {
    grid-template-columns: 1fr;
    height: 650px;
  }
  .chat-list-pane.mob-hide {
    display: none !important;
  }
  .chat-box-pane.mob-hide {
    display: none !important;
  }
}
.chat-list-pane {
  border-left: 1px solid rgba(226, 176, 66, 0.10);
  background: rgba(10, 15, 26, 0.6);
  display: flex;
  flex-direction: column;
  height: 100%;
}
.chat-list-head {
  padding: 1.1rem 1.25rem;
  border-bottom: 1px solid rgba(226, 176, 66, 0.10);
}
.chat-search-input {
  width: 100%;
  background: rgba(255, 255, 255, 0.04);
  border: 1px solid rgba(226, 176, 66, 0.15);
  border-radius: 10px;
  padding: 8px 12px;
  color: var(--txt);
  font-family: inherit;
  font-size: .82rem;
  outline: none;
  transition: all .2s ease;
}
.chat-search-input:focus {
  border-color: var(--gold-lt);
  background: rgba(226, 176, 66, 0.05);
}
.chat-convs-scroll {
  flex: 1;
  overflow-y: auto;
  padding: .5rem;
}
.chat-conv-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 14px;
  border-radius: 12px;
  cursor: pointer;
  transition: all .2s var(--ease);
  position: relative;
  margin-bottom: 4px;
}
.chat-conv-item:hover {
  background: rgba(226, 176, 66, 0.06);
}
.chat-conv-item.is-active {
  background: rgba(226, 176, 66, 0.12);
  border: 1px solid rgba(226, 176, 66, 0.22);
}
.chat-conv-avatar {
  width: 42px; height: 42px;
  border-radius: 12px;
  background: var(--grad);
  color: #060a12;
  font-weight: 800;
  display: flex; align-items: center; justify-content: center;
  font-size: 1rem;
  flex-shrink: 0;
}
.chat-conv-info {
  flex: 1;
  min-width: 0;
}
.chat-conv-name-row {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  margin-bottom: 2px;
}
.chat-conv-name {
  font-weight: 700;
  color: var(--txt);
  font-size: .88rem;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.chat-conv-time {
  font-size: .70rem;
  color: var(--txt3);
}
.chat-conv-snippet {
  font-size: .78rem;
  color: var(--txt2);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.chat-conv-badge {
  background: #ef4444;
  color: #fff;
  font-size: .65rem;
  font-weight: 800;
  padding: 2px 7px;
  border-radius: 10px;
  margin-right: auto;
}

/* Chat Box Right Pane */
.chat-box-pane {
  display: flex;
  flex-direction: column;
  height: 100%;
  background: rgba(8, 12, 22, 0.4);
}
.chat-box-head {
  padding: 1rem 1.4rem;
  border-bottom: 1px solid rgba(226, 176, 66, 0.10);
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: rgba(12, 18, 32, 0.7);
}
.chat-box-head-user {
  display: flex;
  align-items: center;
  gap: 12px;
}
.chat-box-head-name {
  font-weight: 800;
  color: var(--txt);
  font-size: .95rem;
}
.chat-box-head-meta {
  font-size: .74rem;
  color: var(--txt3);
}
.chat-messages-scroll {
  flex: 1;
  overflow-y: auto;
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 14px;
}
.chat-bubble-wrap {
  display: flex;
  flex-direction: column;
  max-width: 75%;
}
.chat-bubble-wrap.incoming {
  align-self: flex-start;
}
.chat-bubble-wrap.outgoing {
  align-self: flex-end;
}
.chat-bubble {
  padding: 11px 16px;
  border-radius: 16px;
  font-size: .88rem;
  line-height: 1.55;
  word-break: break-word;
}
.chat-bubble.incoming {
  background: rgba(30, 41, 59, 0.7);
  color: var(--txt);
  border: 1px solid rgba(255, 255, 255, 0.06);
  border-bottom-right-radius: 4px;
}
.chat-bubble.outgoing {
  background: linear-gradient(135deg, #b88728, #fbbf24);
  color: #060a12;
  font-weight: 600;
  border-bottom-left-radius: 4px;
  box-shadow: 0 4px 14px rgba(226, 176, 66, 0.25);
}
.chat-bubble-time {
  font-size: .68rem;
  margin-top: 4px;
  color: var(--txt3);
}
.chat-bubble-wrap.outgoing .chat-bubble-time {
  text-align: left;
}
.chat-input-area {
  padding: 1rem 1.25rem;
  border-top: 1px solid rgba(226, 176, 66, 0.10);
  background: rgba(12, 18, 32, 0.75);
  display: flex;
  gap: 10px;
  align-items: center;
}
.chat-input-field {
  flex: 1;
  background: rgba(255, 255, 255, 0.04);
  border: 1px solid rgba(226, 176, 66, 0.16);
  border-radius: 12px;
  padding: 12px 14px;
  color: var(--txt);
  font-family: inherit;
  font-size: .88rem;
  outline: none;
  transition: all .2s;
}
.chat-input-field:focus {
  border-color: var(--gold-lt);
  background: rgba(226, 176, 66, 0.06);
}
.chat-send-btn {
  background: var(--grad);
  border: none;
  border-radius: 12px;
  width: 44px; height: 44px;
  display: flex; align-items: center; justify-content: center;
  color: #060a12;
  cursor: pointer;
  flex-shrink: 0;
  transition: all .2s var(--ease);
}
.chat-send-btn:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 16px rgba(226, 176, 66, 0.35);
}
.chat-attach-btn {
  background: rgba(226, 176, 66, 0.12);
  border: 1px solid rgba(226, 176, 66, 0.25);
  border-radius: 12px;
  width: 44px; height: 44px;
  display: flex; align-items: center; justify-content: center;
  color: var(--gold-lt);
  cursor: pointer;
  flex-shrink: 0;
  transition: all .2s;
  font-size: 1.15rem;
}
.chat-attach-btn:hover {
  background: rgba(226, 176, 66, 0.22);
  transform: scale(1.05);
}
.chat-img-thumb {
  max-width: 260px;
  max-height: 260px;
  border-radius: 12px;
  display: block;
  object-fit: cover;
  cursor: pointer;
  transition: transform .2s, box-shadow .2s;
  box-shadow: 0 4px 12px rgba(0,0,0,0.3);
  margin-bottom: 4px;
}
.chat-img-thumb:hover {
  transform: scale(1.02);
}
.chat-empty-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: var(--txt3);
  text-align: center;
  padding: 2rem;
}

/* ════════════════════════════════════════════════
   CARDS – Glassmorphism
════════════════════════════════════════════════ */
.db-card {
  background: rgba(12, 18, 32, 0.45);
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
  border: 1px solid rgba(255, 255, 255, 0.03);
  border-radius: var(--radius);
  padding: 2.15rem;
  margin-bottom: 1.5rem;
  position: relative;
  transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15), inset 0 1px 0 rgba(255, 255, 255, 0.05);
}
.db-card::before {
  content: ''; position: absolute; inset: 0;
  border-radius: var(--radius);
  padding: 1.5px;
  background: linear-gradient(135deg, rgba(226, 176, 66, 0.4), transparent 40%, rgba(226, 176, 66, 0.1));
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
  pointer-events: none;
  opacity: 0.3; transition: opacity 0.4s var(--ease);
}
.db-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.35), inset 0 1px 0 rgba(255, 255, 255, 0.1);
  border-color: rgba(226, 176, 66, 0.1);
}
.db-card:hover::before { opacity: 1; }

.db-card-head {
  display: flex; align-items: center;
  justify-content: space-between;
  margin-bottom: 1.5rem;
  padding-bottom: 1.1rem;
  border-bottom: 1px solid rgba(226,176,66,.08);
  position: relative;
}
.db-card-head::after {
  content: '';
  position: absolute; bottom: -1px; right: 0;
  width: 60px; height: 2px;
  background: var(--grad);
  border-radius: 2px;
  opacity: .7;
}
.db-card-title {
  font-size: .82rem; font-weight: 800;
  letter-spacing: .08em; color: var(--txt2);
  text-transform: uppercase;
  display: flex; align-items: center; gap: 10px;
}
.db-card-title::before {
  content: '';
  width: 4px; height: 18px;
  background: var(--grad);
  border-radius: 3px; display: inline-block; flex-shrink: 0;
  box-shadow: 0 0 8px rgba(226,176,66,.3);
}

/* ════════════════════════════════════════════════
   FORM FIELDS – Modern Glass Style
════════════════════════════════════════════════ */
.f-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1.1rem; }
.f-group { margin-bottom: 1rem; }

.f-label {
  display: flex; align-items: center; gap: 5px;
  font-size: .82rem; font-weight: 700;
  color: var(--txt2); margin-bottom: 8px;
  letter-spacing: .01em;
}
.f-req {
  color: #f87171;
  font-size: .7rem;
}

.f-input, .f-select, .f-textarea {
  width: 100%; padding: 14px 18px;
  background: rgba(6, 10, 18, 0.6);
  border: 1px solid rgba(255, 255, 255, 0.04);
  border-radius: var(--radius-sm);
  color: var(--txt);
  font-family: inherit; font-size: .93rem;
  outline: none; direction: rtl;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: inset 0 2px 5px rgba(0,0,0, 0.2);
}
.f-input:hover, .f-select:hover, .f-textarea:hover {
  background: rgba(10, 16, 28, 0.75);
  border-color: rgba(226, 176, 66, 0.25);
}
.f-input:focus, .f-select:focus, .f-textarea:focus {
  background: rgba(15, 22, 36, 0.85);
  border-color: var(--gold-lt);
  box-shadow: inset 0 2px 5px rgba(0,0,0, 0.2), 0 0 0 4px rgba(226, 176, 66, 0.15);
  transform: translateY(-2px);
}
.f-input::placeholder, .f-textarea::placeholder { color: var(--txt3); opacity: .6; }
.f-select { appearance: none; cursor: pointer; }
.f-select option { background: var(--bg2); color: var(--txt); }
.f-textarea { resize: vertical; min-height: 95px; line-height: 1.7; }

/* ── Translate btn ── */
.btn-tr {
  display: inline-flex; align-items: center; gap: 6px;
  padding: 6px 14px; border-radius: 9px;
  background: rgba(226,176,66,.08);
  color: var(--gold);
  border: 1px solid rgba(226,176,66,.18);
  font-family: inherit; font-size: .75rem; font-weight: 700;
  cursor: pointer;
  transition: all .2s var(--ease);
}
.btn-tr:hover {
  background: rgba(226,176,66,.15);
  border-color: rgba(226,176,66,.3);
  box-shadow: 0 0 12px rgba(226,176,66,.1);
}
.btn-tr.loading svg { animation: spin .9s linear infinite; }
@keyframes spin { to { transform: rotate(360deg) } }

/* ════════════════════════════════════════════════
   FILE UPLOAD – Modern Dashed
════════════════════════════════════════════════ */
.f-file {
  display: flex; flex-direction: column; align-items: center;
  padding: 1.75rem 1rem;
  border: 2px dashed rgba(226,176,66,.18);
  border-radius: 14px; cursor: pointer;
  background: rgba(226,176,66,.02);
  text-align: center;
  transition: all .3s var(--ease);
  position: relative;
  overflow: hidden;
}
.f-file::before {
  content: '';
  position: absolute; inset: 0;
  background: radial-gradient(circle at center, rgba(226,176,66,.04), transparent 70%);
  opacity: 0;
  transition: opacity .3s;
}
.f-file:hover {
  border-color: rgba(226,176,66,.4);
  background: rgba(226,176,66,.06);
  transform: translateY(-1px);
  box-shadow: 0 4px 20px rgba(226,176,66,.06);
}
.f-file:hover::before { opacity: 1; }
.f-file input { display: none; }
.f-file-icon {
  font-size: 2rem; margin-bottom: .6rem;
  filter: drop-shadow(0 2px 8px rgba(226,176,66,.2));
}
.f-file-text { font-size: .84rem; color: var(--txt2); font-weight: 700; position: relative; }
.f-file-hint { font-size: .72rem; color: var(--txt3); margin-top: 5px; position: relative; }
.f-preview {
  width: 100%; max-height: 140px;
  object-fit: cover; border-radius: 10px;
  margin-top: .75rem; display: none;
  border: 1px solid rgba(226,176,66,.15);
  box-shadow: 0 4px 16px rgba(0,0,0,.3);
}

/* ── Dynamic item rows ── */
.item-row {
  display: flex; align-items: center; gap: .4rem; margin-bottom: .35rem;
}
.item-row .f-input { flex: 1; margin-bottom: 0; }
.rm-btn {
  flex-shrink: 0; width: 30px; height: 30px; border-radius: 8px;
  background: rgba(255,59,59,.08); color: #ff7070;
  border: 1px solid rgba(255,59,59,.15);
  font-size: 1.1rem; cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  transition: all .2s var(--ease); line-height: 1;
}
.rm-btn:hover { background: rgba(255,59,59,.18); transform: scale(1.05); }

.add-row-btn {
  display: inline-flex; align-items: center; gap: 6px;
  padding: 7px 18px; border-radius: 10px;
  background: rgba(226,176,66,.05);
  color: var(--gold);
  border: 1px dashed rgba(226,176,66,.2);
  font-family: inherit; font-size: .79rem; font-weight: 700;
  cursor: pointer; margin-top: .5rem;
  transition: all .2s var(--ease);
}
.add-row-btn:hover {
  background: rgba(226,176,66,.12);
  border-color: rgba(226,176,66,.4);
}

/* ── Fee table ── */
.fee-header {
  display: grid; grid-template-columns: 2fr 1.3fr 1fr 30px;
  gap: .4rem; margin-bottom: .4rem; padding: 0 2px;
}
.fee-header span { font-size: .7rem; font-weight: 800; color: var(--txt3); }
.fee-row {
  display: grid; grid-template-columns: 2fr 1.3fr 1fr 30px;
  gap: .4rem; align-items: center; margin-bottom: .35rem;
}
.fee-row .f-input { margin-bottom: 0; }

/* ════════════════════════════════════════════════
   COLLEGE CARDS – Nested Glass
════════════════════════════════════════════════ */
.college-wrap { display: flex; flex-direction: column; gap: .85rem; }

.college-card {
  border: 1px solid rgba(226,176,66,.15);
  border-radius: 16px;
  overflow: hidden;
  background: linear-gradient(165deg, rgba(226,176,66,.03) 0%, rgba(12,18,32,.8) 100%);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  transition: all .3s var(--ease);
}
.college-card:hover {
  border-color: rgba(226,176,66,.3);
  box-shadow: 0 8px 32px rgba(0,0,0,.25), 0 0 0 1px rgba(226,176,66,.05);
  transform: translateY(-1px);
}

.college-header {
  display: flex; align-items: center; gap: .7rem;
  background: rgba(226,176,66,.04);
  border-bottom: 1px solid rgba(226,176,66,.10);
  padding: .75rem 1.1rem;
}
.college-badge {
  font-size: .65rem; font-weight: 900;
  letter-spacing: .12em; text-transform: uppercase;
  color: var(--gold); white-space: nowrap; flex-shrink: 0;
  display: flex; align-items: center; gap: 6px;
}
.college-badge::before {
  content: ''; width: 7px; height: 7px;
  background: var(--gold); border-radius: 50%;
  box-shadow: 0 0 10px rgba(226,176,66,.6); flex-shrink: 0;
  animation: collegePulse 2.5s ease-in-out infinite;
}
@keyframes collegePulse {
  0%, 100% { box-shadow: 0 0 6px rgba(226,176,66,.4); }
  50% { box-shadow: 0 0 14px rgba(226,176,66,.7); }
}
.college-header .clg-name {
  flex: 1; min-width: 0; margin-bottom: 0;
  font-weight: 700; font-size: .92rem;
}
.college-del-btn {
  flex-shrink: 0; width: 32px; height: 32px; border-radius: 9px;
  background: rgba(255,70,70,.06); color: #ff7070;
  border: 1px solid rgba(255,70,70,.15); font-size: .85rem;
  cursor: pointer; display: flex; align-items: center; justify-content: center;
  transition: all .2s var(--ease);
}
.college-del-btn:hover {
  background: rgba(255,70,70,.18);
  transform: scale(1.08);
  box-shadow: 0 0 12px rgba(255,70,70,.1);
}

/* College fee strip */
.college-fee-strip {
  display: grid; grid-template-columns: 1fr 1fr;
  gap: .5rem; padding: .65rem 1.1rem;
  border-bottom: 1px solid rgba(226,176,66,.07);
  background: rgba(0,0,0,.15);
}
.college-fee-field { display: flex; flex-direction: column; gap: 5px; }
.college-fee-label {
  font-size: .64rem; font-weight: 800;
  color: var(--txt3); letter-spacing: .05em;
  padding-right: 3px;
}
.college-fee-strip .f-input { margin-bottom: 0; font-size: .87rem; }

.college-body { padding: .9rem 1.1rem 1.1rem; }

.depts-header-row {
  display: flex; align-items: center; gap: 8px; margin-bottom: .55rem;
}
.depts-header-label {
  font-size: .66rem; font-weight: 900; letter-spacing: .1em;
  text-transform: uppercase; color: var(--txt3); white-space: nowrap;
}
.depts-header-line {
  flex: 1; height: 1px;
  background: linear-gradient(90deg, var(--border), transparent);
}

.dept-col-labels {
  display: grid; grid-template-columns: 1fr 120px 78px 30px;
  gap: .4rem; padding: 0 1px; margin-bottom: .35rem;
}
.dept-col-labels span {
  font-size: .64rem; font-weight: 800; color: var(--txt3); letter-spacing: .04em;
}

.dept-row {
  display: grid; grid-template-columns: 1fr 120px 78px 30px;
  gap: .4rem; align-items: center; margin-bottom: .4rem;
}
.dept-row .f-input {
  margin-bottom: 0; font-size: .86rem;
  background: rgba(6,10,18,.65); border-color: rgba(255,255,255,.05);
}
.dept-row .f-input:focus { background: var(--bg4); }

.dept-del-btn {
  width: 30px; height: 38px; border-radius: 9px;
  background: rgba(255,70,70,.05); color: #ff7070;
  border: 1px solid rgba(255,70,70,.12); font-size: .85rem;
  cursor: pointer; display: flex; align-items: center; justify-content: center;
  transition: all .2s var(--ease); flex-shrink: 0;
}
.dept-del-btn:hover { background: rgba(255,70,70,.15); transform: scale(1.05); }

.add-dept-btn {
  display: inline-flex; align-items: center; gap: 6px;
  padding: 6px 14px; border-radius: 9px;
  background: rgba(100,160,255,.04); color: #84b8ff;
  border: 1px dashed rgba(100,160,255,.18);
  font-family: inherit; font-size: .75rem; font-weight: 700;
  cursor: pointer; margin-top: .3rem;
  transition: all .2s var(--ease);
}
.add-dept-btn:hover {
  background: rgba(100,160,255,.1);
  border-color: rgba(100,160,255,.35);
  box-shadow: 0 0 12px rgba(100,160,255,.06);
}

.add-college-btn {
  display: flex; align-items: center; justify-content: center; gap: 8px;
  width: 100%; padding: 14px;
  border-radius: 14px;
  background: rgba(226,176,66,.03);
  border: 1.5px dashed rgba(226,176,66,.18);
  color: var(--gold);
  font-family: inherit; font-size: .84rem; font-weight: 800;
  cursor: pointer;
  transition: all .25s var(--ease);
}
.add-college-btn:hover {
  background: rgba(226,176,66,.08);
  border-color: rgba(226,176,66,.4);
  box-shadow: 0 0 20px rgba(226,176,66,.06);
}

/* ── Simple dept/fee rows ── */
.fee-header {
  display: grid; grid-template-columns: 1fr 120px 78px 30px;
  gap: .4rem; margin-bottom: .35rem; padding: 0 1px;
}
.fee-header span { font-size: .64rem; font-weight: 800; color: var(--txt3); }
.fee-row {
  display: grid; grid-template-columns: 1fr 120px 78px 30px;
  gap: .4rem; align-items: center; margin-bottom: .35rem;
}
.fee-row .f-input { margin-bottom: 0; }

@media (max-width: 600px) {
  .college-header-inputs { flex-wrap: wrap; }
  .clg-fee, .clg-disc { width: calc(50% - .2rem); }
  .dept-col-labels, .fee-header { display: none; }
  .dept-row, .fee-row {
    grid-template-columns: 1fr 1fr 30px;
    grid-template-areas: "name name del" "fee disc del";
    row-gap: .6rem; column-gap: .4rem;
    padding: .5rem 0; border-bottom: 1px dashed rgba(255,255,255,0.05);
  }
  .dept-row:last-child, .fee-row:last-child { border-bottom: none; }
  .dept-row .f-input:nth-child(1), .fee-row .f-input:nth-child(1) { grid-area: name; }
  .dept-row .f-input:nth-child(2), .fee-row .f-input:nth-child(2) { grid-area: fee; display: block; }
  .dept-row .f-input:nth-child(3), .fee-row .f-input:nth-child(3) { grid-area: disc; display: block; }
  .dept-row button, .fee-row button { grid-area: del; height: 100%; }
}

/* ════════════════════════════════════════════════
   BUTTONS – Premium
════════════════════════════════════════════════ */
.btn-primary {
  display: inline-flex; align-items: center; justify-content: center; gap: 10px;
  padding: 14px 38px; border-radius: 14px;
  background: linear-gradient(135deg, var(--gold), var(--gold-lt));
  color: #05080f; border: none;
  font-family: inherit; font-size: .96rem; font-weight: 900;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  letter-spacing: .03em;
  box-shadow: 0 6px 20px rgba(226, 176, 66, 0.25);
  position: relative;
  overflow: hidden;
  z-index: 1;
}
.btn-primary::before {
  content: ''; position: absolute; inset: 0;
  background: linear-gradient(135deg, var(--gold-lt), #fff6cc);
  z-index: -1; opacity: 0; transition: opacity 0.3s;
}
.btn-primary::after {
  content: ''; position: absolute; top: -50%; left: -75%;
  width: 50%; height: 200%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.6), transparent);
  transform: skewX(-20deg);
  transition: left 0.7s cubic-bezier(0.4, 0, 0.2, 1);
  pointer-events: none;
}
.btn-primary:hover {
  transform: translateY(-3px);
  box-shadow: 0 12px 30px rgba(226, 176, 66, 0.4), 0 0 15px rgba(226, 176, 66, 0.25);
}
.btn-primary:hover::before { opacity: 1; }
.btn-primary:hover::after { left: 125%; }
.btn-primary:active { transform: translateY(1px) scale(0.97); box-shadow: 0 4px 10px rgba(226, 176, 66, 0.3); }

.btn-outline {
  display: inline-flex; align-items: center; gap: 7px;
  padding: 10px 22px; border-radius: 12px;
  background: transparent; color: var(--gold);
  border: 1px solid rgba(226,176,66,.2);
  font-family: inherit; font-size: .84rem; font-weight: 700;
  cursor: pointer;
  transition: all .2s var(--ease);
}
.btn-outline:hover {
  background: rgba(226,176,66,.08);
  border-color: rgba(226,176,66,.35);
}

/* ════════════════════════════════════════════════
   POSTS
════════════════════════════════════════════════ */
.posts-grid { display: flex; flex-direction: column; gap: .85rem; }
.p-card {
  background: var(--glass);
  backdrop-filter: blur(10px);
  border: 1px solid var(--border);
  border-radius: 16px;
  display: flex; overflow: hidden;
  transition: all .25s var(--ease);
}
.p-card:hover {
  border-color: rgba(226,176,66,.18);
  transform: translateY(-2px);
  box-shadow: 0 8px 28px rgba(0,0,0,.25);
}
.p-img { width: 100px; flex-shrink: 0; object-fit: cover; }
.p-body { padding: 1.1rem 1.35rem; flex: 1; min-width: 0; }
.p-title { font-weight: 800; font-size: .95rem; color: var(--txt); }
.p-text {
  color: var(--txt2); font-size: .82rem; line-height: 1.65;
  display: -webkit-box; -webkit-line-clamp: 2;
  -webkit-box-orient: vertical; overflow: hidden; margin-top: .25rem;
}
.p-foot {
  display: flex; align-items: center; gap: 8px;
  margin-top: .7rem; flex-wrap: wrap;
}
.p-date { font-size: .72rem; color: var(--txt3); }

/* ── Chips ── */
.chip {
  display: inline-flex; align-items: center; gap: 5px;
  padding: 3px 11px; border-radius: 20px;
  font-size: .71rem; font-weight: 700;
}
.chip-ok {
  background: rgba(45,190,108,.10); color: #2dbe6c;
  border: 1px solid rgba(45,190,108,.2);
  box-shadow: 0 0 8px rgba(45,190,108,.08);
}
.chip-pending {
  background: rgba(255,170,0,.08); color: #f59e0b;
  border: 1px solid rgba(255,170,0,.18);
}
.chip-dot { width: 5px; height: 5px; border-radius: 50%; background: currentColor; }

/* ── Empty / Locked ── */
.empty-state {
  text-align: center; padding: 4.5rem 1rem; color: var(--txt3);
}
.empty-icon { font-size: 3.2rem; margin-bottom: 1.1rem; filter: grayscale(.15); }
.empty-txt  { font-size: 1.05rem; font-weight: 800; color: var(--txt2); }
.empty-sub  { font-size: .84rem; margin-top: .45rem; }

.locked-state {
  background: var(--glass);
  backdrop-filter: blur(12px);
  border: 1px solid var(--border);
  border-radius: 16px;
  padding: 2.75rem; text-align: center; color: var(--txt2);
}
.locked-icon { font-size: 2.2rem; margin-bottom: .75rem; }

/* ════════════════════════════════════════════════
   MOBILE BOTTOM NAV
════════════════════════════════════════════════ */
.db-mobile-nav {
  display: none;
  position: fixed; bottom: 0; left: 0; right: 0;
  background: rgba(12,18,32,.92);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
  border-top: 1px solid var(--border);
  z-index: 100; padding: .5rem .25rem env(safe-area-inset-bottom, .5rem);
}
.db-mobile-nav-inner {
  display: flex; justify-content: space-around; align-items: center;
}
.db-mob-btn {
  display: flex; flex-direction: column; align-items: center; gap: 4px;
  padding: .5rem .75rem; border: none; background: transparent;
  color: var(--txt3);
  font-family: inherit; font-size: .67rem; font-weight: 700;
  cursor: pointer; border-radius: 12px; min-width: 62px;
  transition: all .2s var(--ease);
}
.db-mob-btn .mob-icon { font-size: 1.3rem; line-height: 1; }
.db-mob-btn.is-active {
  color: var(--gold);
  background: rgba(226,176,66,.09);
  box-shadow: 0 -2px 12px rgba(226,176,66,.08);
}

/* ════════════════════════════════════════════════
   RESPONSIVE
════════════════════════════════════════════════ */
@media (max-width: 960px) {
  .db-main { padding: 1.75rem 2rem 5rem; }
}
@media (max-width: 768px) {
  .db-side { display: none; }
  .db-mobile-nav { display: block; }
  .db-main { padding: 1.375rem 1.125rem 5.5rem; max-width: 100%; }
  .f-row { gap: .75rem; }
}
@media (max-width: 580px) {
  .f-row { grid-template-columns: 1fr; gap: 0; }
  .db-card { padding: 1.25rem; border-radius: 15px; }
}

/* ── Hide fees for public institutions ── */
#academic-section.hide-fees .college-fee-strip {
  display: none !important;
}
#academic-section.hide-fees .dept-col-labels,
#academic-section.hide-fees .dept-row,
#academic-section.hide-fees .fee-header,
#academic-section.hide-fees .fee-row {
  grid-template-columns: 1fr 30px !important;
}
@media (max-width: 600px) {
  #academic-section.hide-fees .dept-row,
  #academic-section.hide-fees .fee-row {
    grid-template-areas: "name del" !important;
    padding: 0 !important;
    border-bottom: none !important;
  }
}
#academic-section.hide-fees .dept-col-labels span:nth-child(2),
#academic-section.hide-fees .dept-col-labels span:nth-child(3),
#academic-section.hide-fees .fee-header span:nth-child(2),
#academic-section.hide-fees .fee-header span:nth-child(3),
#academic-section.hide-fees .f-input:nth-child(2),
#academic-section.hide-fees .f-input:nth-child(3) {
  display: none !important;
}
#academic-section.hide-fees .dept-col-labels,
#academic-section.hide-fees .dept-row,
#academic-section.hide-fees .fee-header,
#academic-section.hide-fees .fee-row {
  grid-template-columns: 1fr 30px !important;
}
#academic-section.hide-fees .dept-col-labels span:nth-child(2),
#academic-section.hide-fees .dept-col-labels span:nth-child(3),
#academic-section.hide-fees .fee-header span:nth-child(2),
#academic-section.hide-fees .fee-header span:nth-child(3) {
  display: none !important;
}
#academic-section.hide-fees .dept-row .f-input:nth-child(2),
#academic-section.hide-fees .dept-row .f-input:nth-child(3),
#academic-section.hide-fees .fee-row .f-input:nth-child(2),
#academic-section.hide-fees .fee-row .f-input:nth-child(3) {
  display: none !important;
}
</style>
@endsection

@section('content')
<div class="db">

  {{-- ══ SIDEBAR ══ --}}
  <aside class="db-side">
    <div class="db-avatar">
      <div class="db-avatar-circle">{{ mb_substr(auth()->user()->name, 0, 1) }}</div>
      <div>
        <div class="db-avatar-name">{{ auth()->user()->name }}</div>
        <div class="db-avatar-email">{{ auth()->user()->email }}</div>
      </div>
    </div>

    <nav class="db-nav">
      <button class="db-nav-btn is-active" onclick="showTab('institution',this)">
        <span class="db-nav-icon">🏫</span> دامەزراوەکەم
      </button>
      <button class="db-nav-btn" onclick="showTab('posts', this)">
        <span class="db-nav-icon">📰</span>
        پۆستەکانم
        @if($posts->count())
          <span class="db-nav-badge">{{ $posts->count() }}</span>
        @endif
      </button>
      <button class="db-nav-btn" onclick="showTab('reviews', this)" data-tab="reviews">
        <span class="db-nav-icon">⭐</span>
        هەڵسەنگاندنەکان
        @if($reviewsCount > 0)
          <span class="db-nav-badge" style="background: rgba(251, 191, 36, 0.2); color: #fbbf24;">{{ $avgRating }} ★</span>
        @endif
      </button>
      <button class="db-nav-btn" onclick="showTab('messages', this)" data-tab="messages">
        <span class="db-nav-icon">💬</span>
        نامەکان
        <span id="nav-unread-badge" class="db-nav-badge" style="{{ $unreadChatsCount > 0 ? '' : 'display:none;' }} background: #ef4444; color: #fff;">{{ $unreadChatsCount }}</span>
      </button>
      <button class="db-nav-btn" onclick="showTab('jobs', this)" data-tab="jobs">
        <span class="db-nav-icon">💼</span>
        هەلی کارەکان
        @if(isset($jobsCount) && $jobsCount > 0)
          <span class="db-nav-badge" style="background: rgba(2, 132, 199, 0.2); color: #38bdf8;">{{ $jobsCount }}</span>
        @endif
      </button>
      <button class="db-nav-btn" onclick="showTab('settings', this)">
        <span class="db-nav-icon">⚙️</span>
        ڕێکخستنەکان
      </button>
      <button class="db-nav-btn" onclick="showTab('new-post',this)">
        <span class="db-nav-icon">✏️</span> پۆستی نوێ
      </button>
    </nav>

    <div class="db-sep" style="margin-top:auto"></div>
    <form method="POST" action="{{ route('portal.logout') }}">
      @csrf
      <button type="submit" class="db-logout-btn">
        <span>🚪</span> دەرچوون
      </button>
    </form>
  </aside>

  {{-- ══ MAIN ══ --}}
  <main class="db-main">



    {{-- ══ TAB: INSTITUTION ══ --}}
    <div class="db-tab is-active" id="tab-institution">
      <div class="pg-head">
        <div class="pg-title">دامەزراوە<span>کەم</span></div>
        <p class="pg-sub">زانیارییەکانت تۆمار بکە تا لە ئەپەکەدا دیار بێت</p>
      </div>

      @if($institution)
        @if(!$institution->approved)
          <div class="nt nt-warn">
            <span class="nt-icon">⏳</span>
            <div>
              <div class="nt-title">چاوەڕوانی پەسەندکردنی ئەدمین</div>
              <div class="nt-sub">پاش پەسەندکردن دەتوانیت پۆست بکەیت</div>
            </div>
          </div>
        @else
          <div class="nt nt-ok">
            <span class="nt-icon">✅</span>
            <span>دامەزراوەکەت پەسەندکراوە — دەتوانیت پۆست بکەیت</span>
          </div>
        @endif

        {{-- ── Quick Stats Grid ── --}}
        <div class="db-stats-grid">
          <div class="db-stat-box" onclick="showTab('reviews', document.querySelector('[data-tab=reviews]'))" style="cursor:pointer;" title="بینینی هەڵسەنگاندنەکان">
            <div class="db-stat-icon-wrap gold">⭐</div>
            <div>
              <div class="db-stat-title">تێکڕای هەڵسەنگاندن</div>
              <div class="db-stat-val">
                {{ $avgRating > 0 ? number_format($avgRating, 1) : '۰' }}
                <span class="db-stat-sub">/ 5</span>
              </div>
              <div class="db-stat-hint">{{ $reviewsCount }} هەڵسەنگاندن لە ئەپدا &larr;</div>
            </div>
          </div>

          <div class="db-stat-box">
            <div class="db-stat-icon-wrap {{ $institution->approved ? 'green' : 'amber' }}">
              {{ $institution->approved ? '✓' : '⏳' }}
            </div>
            <div>
              <div class="db-stat-title">دۆخی دامەزراوە</div>
              <div class="db-stat-val" style="font-size: 1.15rem; color: {{ $institution->approved ? '#34d399' : '#fbbf24' }};">
                {{ $institution->approved ? 'پەسەندکراو' : 'چاوەڕوانی پەسەندە' }}
              </div>
              <div class="db-stat-hint">{{ $institution->approved ? 'لە ئەپڵیکەیشن دیارە' : 'تەنها بۆ ئەدمین دیارە' }}</div>
            </div>
          </div>

          <div class="db-stat-box">
            <div class="db-stat-icon-wrap blue">👁️</div>
            <div>
              <div class="db-stat-title">کۆی سەردان / بینین</div>
              <div class="db-stat-val">
                {{ number_format($institution->views ?? 0) }}
              </div>
              <div class="db-stat-hint">سەردانی بەکارهێنەران لە ئەپدا</div>
            </div>
          </div>
        </div>
      @endif

      <form id="form-inst" method="POST" action="{{ route('portal.institution.save') }}" enctype="multipart/form-data" onsubmit="handleAjaxSubmit(event, 'btn-save-inst')">
        @csrf


        {{-- ناو --}}
        <div class="db-card">
          <div class="db-card-head">
            <div class="db-card-title">📋 ناوی دامەزراوە</div>
          </div>
          <div class="f-row">
            <div class="f-group">
              <label class="f-label">کوردی (سۆرانی) <span class="f-req">*</span></label>
              <input type="text" id="nku" name="nku" class="f-input" placeholder="ناوی کوردی..." value="{{ old('nku', $institution?->nku) }}" required>
              @error('nku') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
            </div>
            <div class="f-group">
              <label class="f-label">کوردی (بادینی)</label>
              <input type="text" id="nkbd" name="nkbd" class="f-input" placeholder="ناوی بادینی..." value="{{ old('nkbd', $institution?->nkbd) }}">
              @error('nkbd') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
            </div>
            <div class="f-group">
              <label class="f-label">عەرەبی</label>
              <input type="text" id="nar" name="nar" class="f-input" placeholder="الاسم بالعربي..." value="{{ old('nar', $institution?->nar) }}">
              @error('nar') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
            </div>
            <div class="f-group">
              <label class="f-label">ئینگلیزی</label>
              <input type="text" id="nen" name="nen" class="f-input" placeholder="English name..." value="{{ old('nen', $institution?->nen) }}" dir="ltr" style="text-align: left;">
              @error('nen') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
            </div>
          </div>
        </div>

        {{-- شوێن و جۆر --}}
        <div class="db-card">
          <div class="db-card-head">
            <div class="db-card-title">📍 شوێن و جۆر</div>
          </div>
          <div class="f-row">
            <div class="f-group">
              <label class="f-label">جۆری دامەزراوە <span class="f-req">*</span></label>
              <select name="type" class="f-select" required onchange="handleTypeChange(this.value)">
                <option value="">— جۆر هەڵبژێرە —</option>
                @foreach($types as $t)
                  <option value="{{ $t->key }}" {{ old('type', $institution?->type) == $t->key ? 'selected' : '' }}>
                    {{ $t->name }}
                  </option>
                @endforeach
              </select>
              @error('type') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
            </div>
            <div class="f-group">
              <label class="f-label">وڵات / هەرێم <span class="f-req">*</span></label>
              <select name="country" class="f-input" required>
                <option value="کوردستان" {{ old('country', $institution?->country ?? 'کوردستان') == 'کوردستان' ? 'selected' : '' }}>کوردستان</option>
                <option value="عێراق" {{ old('country', $institution?->country) == 'عێراق' ? 'selected' : '' }}>عێراق</option>
              </select>
              @error('country') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
            </div>
            <div class="f-group">
              <label class="f-label">شار <span class="f-req">*</span></label>
              <input type="text" name="city" class="f-input" list="cities_list" placeholder="شار هەڵبژێرە یان بنووسە..." value="{{ old('city', $institution?->city) }}" required>
              <datalist id="cities_list">
                @foreach([
                    'هەولێر', 'سلێمانی', 'دهۆک', 'زاخۆ', 'ئامێدی', 'سیمێل', 'شێخان', 'دیانا', 'چۆمان', 'سۆران',
                    'کەرکووک', 'هەڵەبجە', 'رانیە', 'کەلار', 'قلادزێ', 'دوکان', 'دەربەندیخان', 'کفری', 'چەمچەماڵ',
                    'شارەزووری', 'پێنجوێن', 'سەید سادق', 'دوزەخوڕماتو', 'بەغداد', 'مووسڵ', 'بەسرە', 'نەجەف',
                    'کەربەلا', 'حیللە', 'سامەراء', 'تکریت', 'رمادی', 'فەللووجە', 'نەسیریە', 'عەماره', 'کووت',
                    'دیوانیە', 'بعقووبە', 'سینجار', 'تەلاعەفەر'
                ] as $c)
                    <option value="{{ $c }}">
                @endforeach
              </datalist>
              @error('city') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
            </div>
            <div class="f-group">
              <label class="f-label" style="display: flex; align-items: center; justify-content: space-between;">
                <span>ناونیشان</span>
                <button type="button" onclick="getCurrentLocation(this)" style="background: rgba(196,154,60,.15); color: var(--gold-lt); border: 1px solid var(--border2); padding: 3px 10px; border-radius: 6px; font-size: 0.73rem; font-weight: bold; cursor: pointer; display: flex; align-items: center; gap: 4px; transition: all 0.2s;">
                   دیاریکردنی شوێن لەسەر ماپ 
                </button>
              </label>
              <input type="text" id="addr-input" name="addr" class="f-input" placeholder="ناونیشانی تەواو بنووسە یان بەستەری نەخشە دابنێ..." oninput="handleAddrInput(this.value)" value="{{ old('addr', $institution?->addr) }}">
              <p id="map-feedback" style="display: none; font-size: 0.73rem; margin-top: 4px; font-weight: bold;"></p>
              @error('addr') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror

              <!-- Google Maps Picker -->
              <div id="portal-map-wrapper" style="margin-top:10px;">
                <button type="button" onclick="togglePortalMap()" id="toggle-map-btn"
                  style="background:rgba(196,154,60,.12);color:var(--gold-lt);border:1px solid var(--border2);padding:5px 14px;border-radius:8px;font-size:.78rem;font-weight:bold;cursor:pointer;display:flex;align-items:center;gap:6px;transition:all .2s;">
                  🗺️ نەقشە بکەرەوە بۆ دیاریکردنی شوێن
                </button>
                <div id="portal-map-container" style="display:none;margin-top:10px;">
                  <div id="portal-map-picker" style="height:280px;border-radius:10px;border:1px solid var(--border2);overflow:hidden;"></div>
                  <p style="font-size:.72rem;color:var(--txt3);margin-top:5px;">📍 کلیک لەسەر نەقشەکە بکە بۆ دیاریکردنی شوێنی دامەزراوە — Marker دراگ دەکرێت</p>
                </div>
              </div>

              <!-- Hidden inputs to submit to server -->
              <input type="hidden" id="lat-input" name="lat" value="{{ old('lat', $institution?->lat) }}">
              <input type="hidden" id="lng-input" name="lng" value="{{ old('lng', $institution?->lng) }}">
            </div>
          </div>
        </div>

        {{-- پەیوەندی --}}
        <div class="db-card">
          <div class="db-card-head">
            <div class="db-card-title">📞 پەیوەندی</div>
          </div>
          <div class="f-row">
            <div class="f-group">
              <label class="f-label">تەلەفۆن</label>
              <input type="text" name="phone" class="f-input" placeholder="07XX XXX XXXX" value="{{ old('phone', $institution?->phone) }}">
              @error('phone') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
            </div>
            <div class="f-group">
              <label class="f-label">ئیمەیڵ</label>
              <input type="email" name="email" class="f-input" placeholder="info@example.com" value="{{ old('email', $institution?->email) }}" dir="ltr" style="text-align: left;">
              @error('email') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
            </div>
            <div class="f-group">
              <label class="f-label">وێبسایت</label>
              <input type="url" name="web" class="f-input" placeholder="https://..." value="{{ old('web', $institution?->web) }}" dir="ltr" style="text-align: left;">
              @error('web') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
            </div>
          </div>
        </div>

        {{-- کۆلێژ و بەشەکان --}}
        @php
          $currentType  = old('type', $institution?->type);
          $flags        = $typeFlags[$currentType] ?? ['has_colleges' => false, 'has_departments' => false];
          $showSection  = $flags['has_colleges'] || $flags['has_departments'];
          $showColleges = $flags['has_colleges'];
          $showDepts    = $flags['has_departments'];
          $isPublic     = in_array($currentType, ['gov', 'inst5', 'inst2']);
          // Parse colleges — handles: new JSON (with depts+fee), Filament JSON, legacy newline text
          $collegesData = [];
          if (!empty($institution?->colleges)) {
              $decoded = json_decode($institution->colleges, true);
              if (is_array($decoded) && count($decoded)) {
                  foreach ($decoded as $col) {
                      if (!isset($col['name'])) continue;
                      $depts = [];
                      foreach (($col['depts'] ?? $col['departments'] ?? []) as $d) {
                          $depts[] = [
                              'name'     => is_string($d) ? $d : ($d['name'] ?? $d['dept_name'] ?? ''),
                              'name_en'  => is_string($d) ? '' : ($d['name_en'] ?? ''),
                              'name_ar'  => is_string($d) ? '' : ($d['name_ar'] ?? ''),
                              'name_kbd' => is_string($d) ? '' : ($d['name_kbd'] ?? ''),
                              'fee'      => is_string($d) ? '' : ($d['fee'] ?? ''),
                              'discount' => is_string($d) ? '' : ($d['discount'] ?? ''),
                          ];
                      }
                      $collegesData[] = [
                          'name'     => $col['name'],
                          'depts'    => $depts,
                      ];
                  }
              } else {
                  foreach (array_filter(array_map('trim', explode("\n", $institution->colleges))) as $line) {
                      $collegesData[] = ['name' => $line, 'fee' => '', 'discount' => '', 'depts' => []];
                  }
              }
          }
          $nextCiSeed   = count($collegesData);
          // Simple dept rows (for school/non-college types)
          $tuitionList  = is_array($institution?->tuition_plans)
                          ? $institution->tuition_plans
                          : (json_decode($institution?->tuition_plans ?? '[]', true) ?: []);
          
          $simpleDeptRows = [];
          if (count($tuitionList) && !$showColleges) {
              $deptsStr = trim($institution?->depts ?? '');
              $deptsJson = [];
              if (str_starts_with($deptsStr, '[')) {
                  $deptsJson = json_decode($deptsStr, true) ?: [];
              }
              foreach ($tuitionList as $t) {
                  $ku = trim($t['dept'] ?? '');
                  $en = ''; $ar = ''; $kbd = '';
                  foreach ($deptsJson as $dj) {
                      if (($dj['ku'] ?? '') === $ku) {
                          $en = $dj['en'] ?? '';
                          $ar = $dj['ar'] ?? '';
                          $kbd = $dj['kbd'] ?? '';
                          break;
                      }
                  }
                  $t['name_en'] = $en;
                  $t['name_ar'] = $ar;
                  $t['name_kbd'] = $kbd;
                  $simpleDeptRows[] = $t;
              }
          } else {
              $deptsStr = trim($institution?->depts ?? '');
              if (!str_starts_with($deptsStr, '[')) {
                  $deptsList = array_filter(array_map('trim', explode("\n", $deptsStr)));
                  $simpleDeptRows = array_map(fn($d) => ['dept' => $d, 'fee' => '', 'discount' => '', 'name_en' => '', 'name_ar' => '', 'name_kbd' => ''], $deptsList);
              }
          }
        @endphp

        <div id="academic-section" class="db-card {{ $isPublic ? 'hide-fees' : '' }}" style="{{ $showSection ? '' : 'display:none' }}">
          <div class="db-card-head">
            <div class="db-card-title">📚 <span id="academic-title">{{ $showColleges ? 'کۆلێژ و بەشەکان' : 'بەشەکان و پارەدان' }}</span></div>
          </div>

          {{-- Mode 1: Colleges → nested depts + fee/discount per dept --}}
          <div id="group-colleges" style="{{ $showColleges ? '' : 'display:none' }}">
            <div id="colleges-container" class="college-wrap">
              @forelse($collegesData as $col)
                @php $ci = $loop->index; @endphp
                <div class="college-card" data-ci="{{ $ci }}">
                  <div class="college-header">
                    <span class="college-badge">کۆلێژ</span>
                    <input type="text" name="clg[{{ $ci }}][name]" class="f-input clg-name" value="{{ $col['name'] }}" placeholder="بۆ نموونە: کۆلێژی ئەندازیاری">
                    <button type="button" class="college-del-btn" onclick="removeCollege(this)" title="سڕینەوە">✕</button>
                  </div>
                  <div class="college-body">
                    <div class="depts-header-row">
                      <span class="depts-header-label">بەشەکان</span>
                      <span class="depts-header-line"></span>
                    </div>
                    <div class="dept-col-labels">
                      <span>ناوی بەش</span><span>پارە (دینار)</span><span>داشکان %</span><span></span>
                    </div>
                    <div class="depts-wrap">
                      @forelse($col['depts'] as $dept)
                        @php $di = $loop->index; @endphp
                        <div class="dept-row">
                          <div style="display:flex; flex-direction:column; min-width:0;">
                            <input type="text" name="clg[{{ $ci }}][depts][{{ $di }}][name]" class="f-input tr-input" value="{{ $dept['name'] ?? '' }}" placeholder="بۆ نموونە: بەشی کۆمپیوتەر">
                            @if(!empty($dept['name_ar']) || !empty($dept['name_en']) || !empty($dept['name_kbd']))
                              <small class="tr-hint" style="display:block;font-size:.68rem;color:var(--txt3);margin-top:3px;direction:rtl;line-height:1.7"><span style="color:var(--gold);font-weight:800">AR</span> {{ $dept['name_ar'] ?? '' }}&nbsp;&nbsp;<span style="color:var(--gold);font-weight:800">EN</span> {{ $dept['name_en'] ?? '' }}&nbsp;&nbsp;<span style="color:var(--gold);font-weight:800">KBD</span> {{ $dept['name_kbd'] ?? '' }}</small>
                              <input type="hidden" name="clg[{{ $ci }}][depts][{{ $di }}][name_en]" value="{{ $dept['name_en'] ?? '' }}">
                              <input type="hidden" name="clg[{{ $ci }}][depts][{{ $di }}][name_ar]" value="{{ $dept['name_ar'] ?? '' }}">
                              <input type="hidden" name="clg[{{ $ci }}][depts][{{ $di }}][name_kbd]" value="{{ $dept['name_kbd'] ?? '' }}">
                            @endif
                          </div>
                          <input type="text" name="clg[{{ $ci }}][depts][{{ $di }}][fee]" class="f-input currency-input" value="{{ $dept['fee'] ?? '' }}" placeholder="پارە (150,000)">
                          <input type="text" name="clg[{{ $ci }}][depts][{{ $di }}][discount]" class="f-input" value="{{ $dept['discount'] }}" placeholder="داشکان (10%)">
                          <button type="button" class="dept-del-btn" onclick="removeDept(this)">✕</button>
                        </div>
                      @empty
                        <div class="dept-row">
                          <div style="display:flex; flex-direction:column; min-width:0;">
                            <input type="text" name="clg[{{ $ci }}][depts][0][name]" class="f-input tr-input" placeholder="بۆ نموونە: بەشی کۆمپیوتەر">
                          </div>
                          <input type="text" name="clg[{{ $ci }}][depts][0][fee]" class="f-input currency-input" placeholder="پارە (150,000)">
                          <input type="text" name="clg[{{ $ci }}][depts][0][discount]" class="f-input" placeholder="داشکان (10%)">
                          <button type="button" class="dept-del-btn" onclick="removeDept(this)">✕</button>
                        </div>
                      @endforelse
                    </div>
                    <button type="button" class="add-dept-btn" onclick="addDept(this)">＋ بەش زیاد بکە</button>
                  </div>
                </div>
              @empty
                <div class="college-card" data-ci="0">
                  <div class="college-header">
                    <span class="college-badge">کۆلێژ</span>
                    <input type="text" name="clg[0][name]" class="f-input clg-name" placeholder="بۆ نموونە: کۆلێژی ئەندازیاری">
                    <button type="button" class="college-del-btn" onclick="removeCollege(this)">✕</button>
                  </div>
                  <div class="college-body">
                    <div class="depts-header-row">
                      <span class="depts-header-label">بەشەکان</span>
                      <span class="depts-header-line"></span>
                    </div>
                    <div class="dept-col-labels">
                      <span>ناوی بەش</span><span>پارە (دینار)</span><span>داشکان %</span><span></span>
                    </div>
                    <div class="depts-wrap">
                      <div class="dept-row">
                        <input type="text" name="clg[0][depts][0][name]" class="f-input" placeholder="بۆ نموونە: بەشی کۆمپیوتەر">
                        <input type="text" name="clg[0][depts][0][fee]" class="f-input currency-input" placeholder="پارە (150,000)">
                        <input type="text" name="clg[0][depts][0][discount]" class="f-input" placeholder="داشکان (10%)">
                        <button type="button" class="dept-del-btn" onclick="removeDept(this)">✕</button>
                      </div>
                    </div>
                    <button type="button" class="add-dept-btn" onclick="addDept(this)">＋ بەش زیاد بکە</button>
                  </div>
                </div>
              @endforelse
            </div>
            <button type="button" class="add-college-btn" onclick="addCollege()">🏛️ کۆلێژی نوێ زیاد بکە</button>
          </div>

          {{-- Mode 2: Simple depts + fees (schools etc.) --}}
          <div id="group-depts" style="{{ (!$showColleges && $showDepts) ? '' : 'display:none' }}">
            <div class="fee-header">
              <span>ناوی بەش</span>
              <span>پارە (دینار)</span>
              <span>داشکان %</span>
              <span></span>
            </div>
            <div id="depts-list">
              @forelse($simpleDeptRows as $row)
                <div class="fee-row">
                  <div style="display:flex; flex-direction:column; min-width:0;">
                    <input type="text" name="simple_dept[]" class="f-input tr-input" value="{{ $row['dept'] ?? $row['name'] ?? '' }}" placeholder="بۆ نموونە: بەشی کۆمپیوتەر">
                    @if(!empty($row['name_ar']) || !empty($row['name_en']) || !empty($row['name_kbd']))
                      <small class="tr-hint" style="display:block;font-size:.68rem;color:var(--txt3);margin-top:3px;direction:rtl;line-height:1.7"><span style="color:var(--gold);font-weight:800">AR</span> {{ $row['name_ar'] ?? '' }}&nbsp;&nbsp;<span style="color:var(--gold);font-weight:800">EN</span> {{ $row['name_en'] ?? '' }}&nbsp;&nbsp;<span style="color:var(--gold);font-weight:800">KBD</span> {{ $row['name_kbd'] ?? '' }}</small>
                      <input type="hidden" name="simple_dept_en[]" value="{{ $row['name_en'] ?? '' }}">
                      <input type="hidden" name="simple_dept_ar[]" value="{{ $row['name_ar'] ?? '' }}">
                      <input type="hidden" name="simple_dept_kbd[]" value="{{ $row['name_kbd'] ?? '' }}">
                    @endif
                  </div>
                  <input type="text" name="simple_fee[]" class="f-input currency-input" value="{{ $row['fee'] ?? '' }}" placeholder="پارە (150,000)">
                  <input type="text" name="simple_discount[]" class="f-input" value="{{ $row['discount'] ?? '' }}" placeholder="داشکان (10%)">
                  <button type="button" class="dept-del-btn" onclick="removeRow(this)">✕</button>
                </div>
              @empty
                <div class="fee-row">
                  <div style="display:flex; flex-direction:column; min-width:0;">
                    <input type="text" name="simple_dept[]" class="f-input tr-input" placeholder="بۆ نموونە: بەشی کۆمپیوتەر">
                  </div>
                  <input type="text" name="simple_fee[]" class="f-input currency-input" placeholder="پارە (150,000)">
                  <input type="text" name="simple_discount[]" class="f-input" placeholder="داشکان (10%)">
                  <button type="button" class="dept-del-btn" onclick="removeRow(this)">✕</button>
                </div>
              @endforelse
            </div>
            <button type="button" class="add-row-btn" onclick="addSimpleDeptRow()">＋ بەش زیاد بکە</button>
          </div>
        </div>

        {{-- دەربارە --}}
        <div class="db-card">
          <div class="db-card-head">
            <div class="db-card-title">📝 دەربارە</div>
          </div>
          <div class="f-group">
            <label class="f-label">کوردی (سۆرانی)</label>
            <div id="editor-desc" class="quill-editor">{!! old('desc', $institution?->desc) !!}</div>
            <textarea id="desc" name="desc" style="display:none;"></textarea>
            @error('desc') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
          </div>
          <div class="f-group">
            <label class="f-label">کوردی (بادینی)</label>
            <div id="editor-desc_kbd" class="quill-editor">{!! old('desc_kbd', $institution?->desc_kbd) !!}</div>
            <textarea id="desc_kbd" name="desc_kbd" style="display:none;"></textarea>
            @error('desc_kbd') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
          </div>
          <div class="f-group">
            <label class="f-label">عەرەبی</label>
            <div id="editor-desc_ar" class="quill-editor">{!! old('desc_ar', $institution?->desc_ar) !!}</div>
            <textarea id="desc_ar" name="desc_ar" style="display:none;"></textarea>
            @error('desc_ar') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
          </div>
          <div class="f-group">
            <label class="f-label">ئینگلیزی</label>
            <div id="editor-desc_en" class="quill-editor" dir="ltr">{!! old('desc_en', $institution?->desc_en) !!}</div>
            <textarea id="desc_en" name="desc_en" style="display:none;"></textarea>
            @error('desc_en') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
          </div>
        </div>

        {{-- سۆشیال --}}
        <div class="db-card">
          <div class="db-card-head">
            <div class="db-card-title">🔗 سۆشیال میدیا</div>
          </div>
          <div class="f-row">
            <div class="f-group">
              <label class="f-label">Facebook</label>
              <input type="url" name="fb" class="f-input" placeholder="https://facebook.com/..." value="{{ old('fb', $institution?->fb) }}" dir="ltr" style="text-align: left;">
              @error('fb') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
            </div>
            <div class="f-group">
              <label class="f-label">Instagram</label>
              <input type="url" name="ig" class="f-input" placeholder="https://instagram.com/..." value="{{ old('ig', $institution?->ig) }}" dir="ltr" style="text-align: left;">
              @error('ig') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
            </div>
            <div class="f-group">
              <label class="f-label">ساڵی دامەزراندن</label>
              <input type="number" name="founded_year" class="f-input" placeholder="بۆ نموونە: 2015" value="{{ old('founded_year', $institution?->founded_year) }}">
              @error('founded_year') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
            </div>
          </div>
        </div>

        {{-- ڤیدیۆ --}}
        <div class="db-card">
          <div class="db-card-head">
            <div class="db-card-title">🎥 بەستەری ناساندن</div>
          </div>
          <div class="f-group">
            <label class="f-label">بەستەر یان لینکی ناساندن</label>
            <input type="url" name="video" class="f-input" placeholder="https://..." value="{{ old('video', $institution?->video) }}">
            @error('video') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
          </div>
        </div>

        {{-- وێنەکان --}}
        <div class="db-card">
          <div class="db-card-head">
            <div class="db-card-title">🖼 وێنەکان</div>
          </div>
          <div class="f-row">
            <div class="f-group">
              <label class="f-label">لۆگۆ</label>
              <label class="f-file" for="logo-input">
                <input type="file" id="logo-input" name="logo" accept="image/*" onchange="previewImg(this,'logo-prev'); document.getElementById('remove_logo').value='0';">
                <div class="f-file-icon">🏷</div>
                <div class="f-file-text">لۆگۆ هەڵبژێرە</div>
                <div class="f-file-hint">PNG, JPG · max 10MB</div>
              </label>
              @error('logo') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
              <input type="hidden" name="remove_logo" id="remove_logo" value="0">
              @if($institution?->logo)
                <div id="logo-wrapper" style="position:relative; display:inline-block; margin-top:.75rem;">
                  <img src="{{ $institution->logo }}" id="logo-prev" class="f-preview" style="display:block; margin-top:0;" alt="">
                  <button type="button" onclick="document.getElementById('logo-wrapper').style.display='none'; document.getElementById('remove_logo').value='1';" style="position:absolute; top:4px; right:4px; background:#ef4444; color:#fff; border:none; border-radius:50%; width:22px; height:22px; display:flex; align-items:center; justify-content:center; cursor:pointer; font-size:10px;">✕</button>
                </div>
              @else
                <img id="logo-prev" class="f-preview" alt="">
              @endif
            </div>
            <div class="f-group">
              <label class="f-label">وێنەی دامەزراوە</label>
              <label class="f-file" for="img-input">
                <input type="file" id="img-input" name="img" accept="image/*" onchange="previewImg(this,'img-prev'); document.getElementById('remove_img').value='0';">
                <div class="f-file-icon">📸</div>
                <div class="f-file-text">وێنەی سەرەکی هەڵبژێرە</div>
                <div class="f-file-hint">PNG, JPG · max 10MB</div>
              </label>
              @error('img') <div style="color:#ef4444; font-size:.75rem; margin-top:4px;">{{ $message }}</div> @enderror
              <input type="hidden" name="remove_img" id="remove_img" value="0">
              @if($institution?->img)
                <div id="img-wrapper" style="position:relative; display:inline-block; margin-top:.75rem;">
                  <img src="{{ $institution->img }}" id="img-prev" class="f-preview" style="display:block; margin-top:0;" alt="">
                  <button type="button" onclick="document.getElementById('img-wrapper').style.display='none'; document.getElementById('remove_img').value='1';" style="position:absolute; top:4px; right:4px; background:#ef4444; color:#fff; border:none; border-radius:50%; width:22px; height:22px; display:flex; align-items:center; justify-content:center; cursor:pointer; font-size:10px;">✕</button>
                </div>
              @else
                <img id="img-prev" class="f-preview" alt="">
              @endif
            </div>
          </div>
        </div>

        <div style="display:flex;align-items:center;gap:1rem;margin-top:.5rem;padding-top:1.5rem;border-top:1px solid var(--border)">
          <button type="submit" id="btn-save-inst" class="btn-primary" style="padding:14px 42px;font-size:.95rem">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink:0" class="btn-icon"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
            <span>پاشەکەوتکردن</span>
          </button>
          
          {{-- وەرگێڕانی گشتی --}}
          <button type="button" id="btn-translate-all" onclick="translateAll()" style="background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.1); color: #fff; padding: 14px 20px; border-radius: 8px; font-size: .95rem; cursor: pointer; display: flex; align-items: center; gap: 8px;">
            <span>🌐</span> <span>وەرگێڕانی گشتی</span>
          </button>
          <span style="font-size:.78rem;color:var(--txt3);font-weight:600">گۆڕانکارییەکانت خۆکارانە دەنێردرێن</span>
        </div>
      </form>
    </div>

    {{-- ══ TAB: POSTS ══ --}}
    <div class="db-tab" id="tab-posts">
      <div class="pg-head-row">
        <div class="pg-head" style="margin-bottom:0">
          <div class="pg-title">پۆستەکا<span>نم</span></div>
          <p class="pg-sub">{{ $posts->count() }} پۆست بڵاوکراوەتەوە</p>
        </div>
        @if($institution?->approved)
          <button class="btn-primary" style="padding:9px 20px;font-size:.83rem" onclick="showTab('new-post',null);syncMobile('new-post')">+ پۆستی نوێ</button>
        @endif
      </div>

      @forelse($posts as $post)
        <div class="p-card">
          @if($post->image)
            <img src="{{ $post->image }}" class="p-img" alt="">
          @endif
          <div class="p-body">
            <div class="p-title">{{ $post->title }}</div>
            <div class="p-text">{!! Str::limit(strip_tags($post->content), 120) !!}</div>
            <div class="p-foot">
              <span class="chip {{ $post->approved ? 'chip-ok' : 'chip-pending' }}">
                <span class="chip-dot"></span>
                {{ $post->approved ? 'پەسەندکراو' : 'چاوەڕوانی پەسەند' }}
              </span>
              <span class="p-date">{{ $post->created_at->diffForHumans() }}</span>
              <form method="POST" action="{{ route('portal.posts.delete', $post->id) }}" onsubmit="return confirm('دڵنیایت؟')" style="margin-right:auto">
                @csrf @method('DELETE')
                <button type="submit" style="background:none;border:none;cursor:pointer;color:#ff7070;font-size:.78rem;font-family:inherit;font-weight:700">🗑 سڕینەوە</button>
              </form>
            </div>
          </div>
        </div>
      @empty
        <div class="db-card" style="text-align:center;padding:3rem 1rem">
          <div style="font-size:3rem;margin-bottom:1rem;opacity:0.5">📭</div>
          <p style="color:var(--txt2);font-weight:600">هێشتا هیچ پۆستێکت نەکردووە.</p>
        </div>
      @endforelse

      @if($posts->hasPages())
        <div style="margin-top: 1.5rem;">
          {{ $posts->links() }}
        </div>
      @endif
    </div>

    {{-- ══ TAB: REVIEWS ══ --}}
    <div class="db-tab" id="tab-reviews">
      <div class="pg-head">
        <div class="pg-title">هەڵسەنگاندن<span>ەکانی بەکارهێنەران</span></div>
        <p class="pg-sub">ڕا، بۆچوون و ئەستێرەی بەکارهێنەرانی ئەپڵیکەیشن بۆ دامەزراوەکەت</p>
      </div>

      @if($institution)
        {{-- Overview Card with Big Score and Breakdown --}}
        <div class="review-overview-card">
          <div class="review-score-box">
            <div class="review-big-score">{{ $avgRating > 0 ? number_format($avgRating, 1) : '۰.۰' }}</div>
            <div class="review-stars-row">
              @for($i = 1; $i <= 5; $i++)
                <span>{{ $i <= round($avgRating) ? '★' : '☆' }}</span>
              @endfor
            </div>
            <div class="review-score-count">
              لە کۆی {{ number_format($reviewsCount) }} هەڵسەنگاندن لە ئەپدا
            </div>
          </div>

          <div class="rating-dist-list">
            @foreach([5, 4, 3, 2, 1] as $star)
              @php
                $count = $ratingDist[$star] ?? 0;
                $pct = $reviewsCount > 0 ? round(($count / $reviewsCount) * 100) : 0;
              @endphp
              <div class="rating-dist-item">
                <span style="width: 60px; font-weight: 700;">{{ $star }} ئەستێرە</span>
                <div class="rating-dist-bar">
                  <div class="rating-dist-fill" style="width: {{ $pct }}%;"></div>
                </div>
                <span class="rating-dist-num">{{ $count }} ({{ $pct }}%)</span>
              </div>
            @endforeach
          </div>
        </div>

        {{-- Reviews List --}}
        <div class="db-card-head" style="margin-top: 1.5rem; margin-bottom: 1.25rem;">
          <div class="db-card-title">💬 بۆچوونی بەکارهێنەران ({{ $reviews->count() }})</div>
        </div>

        @forelse($reviews as $rev)
          <div class="review-item-card">
            <div class="review-item-head">
              <div class="review-user-info">
                <div class="review-user-avatar">
                  @if(!empty($rev->user_avatar))
                    <img src="{{ $rev->user_avatar }}" alt="{{ $rev->user_name }}">
                  @else
                    {{ mb_substr($rev->user_name ?? 'ب', 0, 1) }}
                  @endif
                </div>
                <div>
                  <div class="review-user-name">{{ $rev->user_name ?? 'بەکارهێنەر' }}</div>
                  <div class="review-date">{{ $rev->created_at ? $rev->created_at->diffForHumans() : '' }}</div>
                </div>
              </div>
              <div class="review-stars" title="{{ $rev->rating }} ئەستێرە">
                @for($s = 1; $s <= 5; $s++)
                  <span>{{ $s <= $rev->rating ? '★' : '☆' }}</span>
                @endfor
              </div>
            </div>

            @if(!empty($rev->comment))
              <div class="review-comment">
                “{{ $rev->comment }}”
              </div>
            @else
              <div style="font-size: .8rem; color: var(--txt3); font-style: italic; padding: .5rem 0;">
                (تەنها هەڵسەنگاندنی ئەستێرەی داناوە بێ بۆچوونی نوسراو)
              </div>
            @endif
          </div>
        @empty
          <div class="db-card" style="text-align: center; padding: 3.5rem 1.5rem;">
            <div style="font-size: 3.2rem; margin-bottom: 1rem; opacity: 0.6;">⭐</div>
            <div style="font-size: 1.15rem; font-weight: 800; color: var(--txt); margin-bottom: .5rem;">هێشتا هیچ هەڵسەنگاندنێک تۆمار نەکراوە</div>
            <p style="color: var(--txt2); font-size: .88rem; max-width: 480px; margin: 0 auto; line-height: 1.6;">
              کاتێک قوتابیان و بەکارهێنەران لەڕێگەی ئەپڵیکەیشنی مۆبایلەوە ئەستێرە و بۆچوونی خۆیان دەنووسن، دەستبەجێ لێرەدا نیشان دەدرێت.
            </p>
          </div>
        @endforelse

      @else
        <div class="db-card" style="text-align:center; padding: 3rem 1rem;">
          <div style="font-size: 3rem; margin-bottom: 1rem;">🏫</div>
          <p style="color: var(--txt2); font-weight: 600;">تکایە سەرەتا زانیارییەکانی دامەزراوەکەت تۆمار بکە.</p>
        </div>
      @endif
    </div>

    {{-- ══ TAB: MESSAGES / CHAT ══ --}}
    <div class="db-tab" id="tab-messages">
      <div class="pg-head">
        <div class="pg-title">چات و نامەکان<span>ی قوتابیان</span></div>
        <p class="pg-sub">پەیوەندی ڕاستەوخۆ و وەڵامدانەوەی پرسیاری بەکارهێنەرانی ئەپڵیکەیشن</p>
      </div>

      @if($institution)
        <div class="chat-container">
          {{-- Left: Conversation List --}}
          <div class="chat-list-pane" id="chat-list-pane">
            <div class="chat-list-head">
              <input type="text" class="chat-search-input" id="chat-search" placeholder="گەڕان لە ناوی قوتابیان..." oninput="filterChatList(this.value)">
            </div>
            <div class="chat-convs-scroll" id="chat-convs-list">
              @forelse($conversations as $conv)
                <div class="chat-conv-item" id="conv-item-{{ $conv->id }}" onclick="selectConversation({{ $conv->id }}, '{{ addslashes($conv->user?->name ?? 'بەکارهێنەر') }}', '{{ addslashes($conv->user?->phone ?? $conv->user?->email ?? '') }}')">
                  <div class="chat-conv-avatar">
                    {{ mb_substr($conv->user?->name ?? 'ق', 0, 1) }}
                  </div>
                  <div class="chat-conv-info">
                    <div class="chat-conv-name-row">
                      <span class="chat-conv-name">{{ $conv->user?->name ?? 'بەکارهێنەر' }}</span>
                      <span class="chat-conv-time">{{ $conv->last_message_at ? $conv->last_message_at->diffForHumans(null, true, true) : '' }}</span>
                    </div>
                    <div style="display: flex; align-items: center; justify-content: space-between; gap: 8px;">
                      <span class="chat-conv-snippet" id="conv-snippet-{{ $conv->id }}">{{ $conv->last_message ?? 'نامەی نوێ' }}</span>
                      <span class="chat-conv-badge" id="conv-badge-{{ $conv->id }}" style="{{ $conv->institution_unread_count > 0 ? '' : 'display:none;' }}">
                        {{ $conv->institution_unread_count }}
                      </span>
                    </div>
                  </div>
                </div>
              @empty
                <div style="text-align: center; padding: 2.5rem 1rem; color: var(--txt3); font-size: .84rem;">
                  <div style="font-size: 2.2rem; margin-bottom: .5rem; opacity: .5;">💬</div>
                  هێشتا هیچ نامەیەک لە ئەپەوە نەهاتووە.
                </div>
              @endforelse
            </div>
          </div>

          {{-- Right: Chat Box --}}
          <div class="chat-box-pane" id="chat-box-pane">
            <div class="chat-box-head" id="chat-box-head" style="display: none;">
              <div class="chat-box-head-user">
                <button type="button" class="btn btn-ghost btn-xs" style="margin-left: 8px; font-weight: 800;" id="btn-back-convs" onclick="backToConvsList()">
                  &rarr; گەڕانەوە
                </button>
                <div class="chat-conv-avatar" id="active-chat-avatar" style="width: 36px; height: 36px; font-size: .9rem;">ق</div>
                <div>
                  <div class="chat-box-head-name" id="active-chat-name">ناوی بەکارهێنەر</div>
                  <div class="chat-box-head-meta" id="active-chat-meta">لە ئەپڵیکەیشنی مۆبایلەوە</div>
                </div>
              </div>
              <span class="badge badge-success" style="font-size: .72rem; padding: 4px 10px; border-radius: 20px; background: rgba(16,185,129,0.15); color: #34d399;">چالاک</span>
            </div>

            <div class="chat-messages-scroll" id="chat-messages-scroll">
              <div class="chat-empty-box" id="chat-loading-placeholder">
                <div style="font-size: 2.8rem; margin-bottom: .75rem; opacity: .4;">💬</div>
                <div style="font-size: 1rem; font-weight: 800; color: var(--txt2);">گفتوگۆیەک هەڵبژێرە بۆ بینینی نامەکان</div>
                <p style="font-size: .82rem; margin-top: 4px; color: var(--txt3);">دەتوانیت لێرەوە وەڵامی پرسیارەکانی قوتابیان بدەیتەوە</p>
              </div>
            </div>

            <div id="chat-selected-img-preview" style="display: none; padding: 8px 14px; background: rgba(12, 18, 32, 0.9); border-top: 1px solid rgba(226, 176, 66, 0.15); align-items: center; justify-content: space-between;">
              <div style="display: flex; align-items: center; gap: 10px;">
                <img id="chat-preview-img-tag" src="" style="width: 48px; height: 48px; object-fit: cover; border-radius: 8px; border: 1px solid rgba(226, 176, 66, 0.3);" />
                <div>
                  <div id="chat-preview-filename" style="font-size: .82rem; font-weight: 600; color: var(--txt); max-width: 220px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"></div>
                  <div style="font-size: .72rem; color: var(--gold-lt);">ئامادەیە بۆ ناردن</div>
                </div>
              </div>
              <button type="button" class="btn btn-ghost btn-xs" onclick="clearSelectedChatImage()" title="لابردن" style="color: #ef4444; font-size: 1.1rem; font-weight: 800; padding: 4px 8px;">✕</button>
            </div>

            <form class="chat-input-area" id="chat-send-form" style="display: none;" onsubmit="sendChatReply(event)">
              <input type="file" id="chat-reply-image" accept="image/*" style="display: none;" onchange="handleChatImageSelect(this)">
              <button type="button" class="chat-attach-btn" onclick="document.getElementById('chat-reply-image').click()" title="هاوپێچکردنی وێنە">
                📷
              </button>
              <input type="text" class="chat-input-field" id="chat-reply-input" placeholder="وەڵامەکەت لێرە بنووسە..." autocomplete="off">
              <button type="submit" class="chat-send-btn" id="btn-chat-send" title="ناردن">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="transform: rotate(180deg);">
                  <line x1="22" y1="2" x2="11" y2="13"></line>
                  <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                </svg>
              </button>
            </form>
          </div>
        </div>
      @else
        <div class="db-card" style="text-align:center; padding: 3rem 1rem;">
          <div style="font-size: 3rem; margin-bottom: 1rem;">🏫</div>
          <p style="color: var(--txt2); font-weight: 600;">تکایە سەرەتا زانیارییەکانی دامەزراوەکەت تۆمار بکە.</p>
        </div>
      @endif
    </div>

    {{-- ══ TAB: JOBS ══ --}}
    <div class="db-tab" id="tab-jobs">
      <div class="pg-head">
        <div class="pg-title">هەلی کار<span>ەکان</span></div>
        <p class="pg-sub">ڕاگەیاندنی پێداویستی مامۆستا و ستاف لە ئەپەکەدا بە فەرمی لەلایەن دامەزراوەکەتەوە</p>
      </div>

      @if($institution)
        @if(!$institution->approved)
          <div class="nt nt-warn">
            <span class="nt-icon">⏳</span>
            <div>
              <div class="nt-title">چاوەڕوانی پەسەندکردنی دامەزراوە</div>
              <div class="nt-sub">پاش پەسەندکردن لەلایەن ئەدمین، هەلی کارەکانت لە ئەپەکەدا بە فەرمی دەردەکەون</div>
            </div>
          </div>
        @else
          <div class="nt nt-ok">
            <span class="nt-icon">✅</span>
            <span>دامەزراوەکەت پەسەندکراوە — دەتوانیت هەلی کار بڵاوبکەیتەوە و ڕاستەوخۆ دەردەکەوێت</span>
          </div>
        @endif

        {{-- ── Quick Stats Grid ── --}}
        <div class="db-stats-grid">
          <div class="db-stat-box">
            <div class="db-stat-icon-wrap blue">💼</div>
            <div>
              <div class="db-stat-title">کۆی هەلی کارەکان</div>
              <div class="db-stat-val" id="stat-jobs-total">{{ isset($jobs) ? $jobs->count() : 0 }}</div>
              <div class="db-stat-hint">هەموو هەلی کارە تۆمارکراوەکان</div>
            </div>
          </div>

          <div class="db-stat-box">
            <div class="db-stat-icon-wrap green">✓</div>
            <div>
              <div class="db-stat-title">هەلی کارە چالاکەکان</div>
              <div class="db-stat-val" style="color: #34d399;" id="stat-jobs-active">
                {{ isset($jobs) ? $jobs->where('is_active', true)->count() : 0 }}
              </div>
              <div class="db-stat-hint">لە ئەپڵیکەیشن بەردەستن</div>
            </div>
          </div>

          <div class="db-stat-box">
            <div class="db-stat-icon-wrap gold">👁️</div>
            <div>
              <div class="db-stat-title">کۆی بینینەکان</div>
              <div class="db-stat-val" id="stat-jobs-views">
                {{ isset($jobs) ? number_format($jobs->sum('views_count')) : 0 }}
              </div>
              <div class="db-stat-hint">سەردانی بەکارهێنەران لە ئەپدا</div>
            </div>
          </div>
        </div>
      @endif

      {{-- فۆڕمی بڵاوکردنەوە یان دەستکاریکردنی هەلی کار --}}
      <form id="portal-job-form" onsubmit="submitPortalJob(event)">
        <input type="hidden" id="job-edit-id" value="">

        {{-- کارتی ١: ناونیشان و پۆلێنی کار --}}
        <div class="db-card">
          <div class="db-card-head">
            <div class="db-card-title">📋 ناونیشان و پۆلێنی کار</div>
          </div>
          <div class="f-row">
            <div class="f-group">
              <label class="f-label" style="display:flex; justify-content:space-between; align-items:center;">
                <span>ناونیشانی کار <span class="f-req">*</span></span>
                <button type="button" class="btn-tr" onclick="translateJobTitle(this)" title="وەرگێڕانی ئۆتۆماتیکی بۆ زمانەکانی تر">
                  🌐 وەرگێڕان
                </button>
              </label>
              <input type="text" class="f-input" name="title" id="job-title-ku" required placeholder="بۆ نموونە: مامۆستای بیرکاری بۆ پۆلی 12">
              <div id="job-title-tr-hint" style="display:none; margin-top:6px; padding:8px 12px; background:rgba(255,255,255,0.04); border-radius:8px; font-size:.8rem; color:var(--txt2); line-height:1.8;"></div>
              <input type="hidden" name="title_ar" id="job-title-ar">
              <input type="hidden" name="title_en" id="job-title-en">
              <input type="hidden" name="title_kbd" id="job-title-kbd">
            </div>

            <div class="f-group">
              <label class="f-label">پۆلێنکردنی کار <span class="f-req">*</span></label>
              <select class="f-select" name="category" id="job-category-select" required onchange="toggleJobCategoryOther(this)">
                <option value="teacher">👨‍🏫 مامۆستا</option>
                <option value="admin">💼 کارگێڕی و ژمێریاری</option>
                <option value="support">🤝 چاودێری و خزمەتگوزاری</option>
                <option value="other">✏️ تر (دیاریکردنی تر)</option>
              </select>
              <input type="text" class="f-input" name="category_custom" id="job-category-other" placeholder="ناوی پۆلێنەکەت بنووسە..." style="display:none; margin-top:8px;">
            </div>

            <div class="f-group">
              <label class="f-label">وانە / پسپۆڕی</label>
              <input type="text" class="f-input" name="subject" id="job-subject" placeholder="وەک: ئینگلیزی، کیمیا، باخچە، مێژوو...">
            </div>

            <div class="f-group">
              <label class="f-label">قۆناغی خوێندن</label>
              <input type="text" class="f-input" name="education_level" id="job-edu-level" placeholder="وەک: باخچە، بنەڕەتی، ئامادەیی، پەیمانگا، زانکۆ">
            </div>
          </div>
        </div>

        {{-- کارتی ٢: شێواز و مەرجەکانی کار --}}
        <div class="db-card">
          <div class="db-card-head">
            <div class="db-card-title">⚖️ شێواز و مەرجەکانی کار</div>
          </div>
          <div class="f-row">
            <div class="f-group">
              <label class="f-label">جۆری دەوام <span class="f-req">*</span></label>
              <select class="f-select" name="employment_type" id="job-emp-type" required>
                <option value="full_time">تەواوکات (بەیانیان)</option>
                <option value="part_time">نیوەکات (ئێواران)</option>
                <option value="temporary">کاتی / وانەبێژ</option>
              </select>
            </div>

            <div class="f-group">
              <label class="f-label">ڕەگەزی داواکراو</label>
              <select class="f-select" name="gender" id="job-gender">
                <option value="any">گرنگ نییە (نێر یان مێ)</option>
                <option value="female">تەنها مێ</option>
                <option value="male">تەنها نێر</option>
              </select>
            </div>

            <div class="f-group">
              <label class="f-label">ئەزموونی پێویست</label>
              <input type="text" class="f-input" name="experience_years" id="job-exp" placeholder="وەک: بێ ئەزموون، ٢ ساڵ بەسەرەوە...">
            </div>

            <div class="f-group">
              <label class="f-label">مووچە (ئارەزوومەندانە)</label>
              <input type="text" class="f-input" name="salary_range" id="job-salary" placeholder="وەک: 700,000 - 900,000 د.ع یان بەپێی ڕێککەوتن">
            </div>
          </div>
        </div>

        {{-- کارتی ٣: وەسف و مەرجەکان --}}
        <div class="db-card">
          <div class="db-card-head">
            <div class="db-card-title">📝 وەسف و وردەکارییەکانی کار</div>
          </div>
          <div class="f-group">
            <label class="f-label">وەسفی کار و ئەرکەکان <span class="f-req">*</span></label>
            <textarea class="f-textarea" name="description" id="job-desc" rows="4" required placeholder="وەسفی کارەکە بنووسە، ئەرکەکان، کاتەکانی وانەوتنەوە و بەرپرسیاریەتییەکان..."></textarea>
          </div>
          <div class="f-group" style="margin-bottom:0;">
            <label class="f-label">مەرجەکانی وەرگرتن (ئارەزوومەندانە)</label>
            <textarea class="f-textarea" name="requirements" id="job-req" rows="3" placeholder="مەرجەکان، بڕوانامەی داواکراو، شارەزایی زمان، مەرجە تایبەتەکان..."></textarea>
          </div>
        </div>

        {{-- کارتی ٤: شوێن و پەیوەندی --}}
        <div class="db-card">
          <div class="db-card-head">
            <div class="db-card-title">📍 شوێن و زانیاری پەیوەندی</div>
          </div>
          <div class="f-row">
            <div class="f-group">
              <label class="f-label">شار <span class="f-req">*</span></label>
              <input type="text" name="city" id="job-city" class="f-input" list="cities_list" placeholder="شار هەڵبژێرە یان بنووسە..." value="{{ old('city', $institution?->city ?? 'هەولێر') }}" required>
            </div>

            <div class="f-group">
              <label class="f-label">ژمارەی پەیوەندی / مۆبایل <span class="f-req">*</span></label>
              <input type="text" class="f-input" name="contact_phone" id="job-phone" required placeholder="0750 000 0000" value="{{ $institution->phone ?? '' }}">
            </div>

            <div class="f-group">
              <label class="f-label">ژمارەی واتسئەپ</label>
              <input type="text" class="f-input" name="contact_whatsapp" id="job-wa" placeholder="0750 000 0000" value="{{ $institution->wa ?? '' }}">
            </div>

            <div class="f-group">
              <label class="f-label">ئیمەیڵ بۆ ناردنی CV</label>
              <input type="email" class="f-input" name="contact_email" id="job-email" placeholder="hr@institution.krd" value="{{ $institution->email ?? '' }}" dir="ltr" style="text-align: left;">
            </div>
          </div>
        </div>

        {{-- دوگمەی سەرەکی --}}
        <div style="display:flex;align-items:center;gap:1rem;margin-top:.5rem;margin-bottom:2.25rem;padding-top:1.5rem;border-top:1px solid var(--border)">
          <button type="submit" id="btn-save-job" class="btn-primary" style="padding:14px 42px;font-size:.95rem">
            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="btn-icon"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
            <span id="btn-job-submit-text">بڵاوکردنەوەی هەلی کار</span>
          </button>

          <button type="button" id="btn-cancel-job-edit" onclick="resetJobForm()" style="display:none; background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.1); color: #fff; padding: 14px 22px; border-radius: 8px; font-size: .95rem; cursor: pointer; transition: all .2s;">
            ✕ پاشگەزبوونەوە
          </button>

          <span style="font-size:.78rem;color:var(--txt3);font-weight:600" id="job-form-hint">هەلی کارەکە دەستبەجێ لە ئەپڵیکەیشن بڵاودەبێتەوە</span>
        </div>
      </form>

      {{-- Published Jobs List --}}
      <div class="db-card">
        <div class="db-card-head">
          <div class="db-card-title">💼 هەلی کارە بڵاوکراوەکانی دامەزراوەکەت (<span id="portal-jobs-count">{{ isset($jobs) ? $jobs->count() : 0 }}</span>)</div>
        </div>

        <div id="portal-jobs-list">
          @if(isset($jobs) && $jobs->count())
            @foreach($jobs as $job)
              <div class="job-portal-card" id="job-row-{{ $job->id }}" style="background: rgba(10, 16, 28, 0.6); border: 1px solid rgba(255, 255, 255, 0.05); border-radius: 14px; padding: 1.35rem; margin-bottom: 1rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1.25rem; transition: all .25s;">
                <div style="flex: 1; min-width: 260px;">
                  <div style="display: flex; align-items: center; gap: .75rem; flex-wrap: wrap; margin-bottom: .45rem;">
                    <div style="font-size: 1.15rem; font-weight: 900; color: var(--txt);">{{ $job->title }}</div>
                    <span class="chip {{ $job->is_active ? 'chip-ok' : 'chip-pending' }}" id="job-status-chip-{{ $job->id }}">
                      <span class="chip-dot"></span>
                      <span id="job-status-text-{{ $job->id }}">{{ $job->is_active ? 'چالاک' : 'ناچالاک' }}</span>
                    </span>
                    @if($job->category)
                      <span style="font-size: .75rem; font-weight: 700; background: rgba(226, 176, 66, 0.12); color: var(--gold); padding: 3px 9px; border-radius: 6px; border: 1px solid rgba(226, 176, 66, 0.2);">
                        @if($job->category == 'teacher') 👨‍🏫 مامۆستا
                        @elseif($job->category == 'admin') 💼 کارگێڕی
                        @elseif($job->category == 'support') 🤝 خزمەتگوزاری
                        @else ✏️ {{ $job->category }}
                        @endif
                      </span>
                    @endif
                  </div>

                  <div style="display: flex; gap: .85rem; flex-wrap: wrap; font-size: .85rem; color: var(--txt2); line-height: 1.7;">
                    <span style="color: var(--gold-lt);">📍 {{ $job->city }}</span>
                    <span>⏰ {{ $job->employment_type == 'full_time' ? 'تەواوکات' : ($job->employment_type == 'part_time' ? 'نیوەکات' : 'کاتی') }}</span>
                    @if($job->subject)
                      <span>📚 {{ $job->subject }}</span>
                    @endif
                    @if($job->education_level)
                      <span>🎓 {{ $job->education_level }}</span>
                    @endif
                    @if($job->salary_range)
                      <span style="color: #34d399; font-weight: 700;">💰 {{ $job->salary_range }}</span>
                    @endif
                    <span>📞 {{ $job->contact_phone }}</span>
                    <span style="color: #60a5fa;">👁️ {{ $job->views_count ?? 0 }} بینین</span>
                    <span style="color: var(--txt3);">📅 {{ $job->created_at ? $job->created_at->diffForHumans() : '' }}</span>
                  </div>

                  @if($job->description)
                    <div style="font-size: .83rem; color: var(--txt3); margin-top: .6rem; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; line-height: 1.6;">
                      {{ Str::limit($job->description, 160) }}
                    </div>
                  @endif
                </div>

                <div style="display: flex; align-items: center; gap: .6rem; flex-shrink: 0;">
                  <button type="button" onclick='editPortalJob(@json($job))' style="background: rgba(226, 176, 66, 0.12); color: var(--gold); border: 1px solid rgba(226, 176, 66, 0.25); padding: .55rem 1rem; font-size: .85rem; font-weight: 700; border-radius: 9px; cursor: pointer; display: flex; align-items: center; gap: 5px; transition: all .2s;">
                    ✏️ دەستکاری
                  </button>

                  <button type="button" onclick="togglePortalJobActive({{ $job->id }})" id="btn-toggle-active-{{ $job->id }}" style="background: rgba(255, 255, 255, 0.06); color: var(--txt2); border: 1px solid rgba(255, 255, 255, 0.1); padding: .55rem .9rem; font-size: .85rem; border-radius: 9px; cursor: pointer; transition: all .2s;" title="گۆڕینی دۆخی کارایی">
                    {{ $job->is_active ? '⏸️ ڕاگرتن' : '▶️ کاراکردن' }}
                  </button>

                  <button type="button" style="background: rgba(239, 68, 68, 0.12); color: #f87171; border: 1px solid rgba(239, 68, 68, 0.25); padding: .55rem .9rem; font-size: .85rem; font-weight: 700; border-radius: 9px; cursor: pointer; display: flex; align-items: center; gap: 4px; transition: all .2s;" onclick="deletePortalJob({{ $job->id }})">
                    🗑️ سڕینەوە
                  </button>
                </div>
              </div>
            @endforeach
          @else
            <div id="portal-jobs-empty" style="text-align:center; padding:3.5rem 1rem; color:var(--txt2);">
              <div style="font-size:3.5rem; margin-bottom:.75rem; opacity: 0.6;">💼</div>
              <div style="font-weight:800; font-size:1.1rem; color: var(--txt);">تا ئێستا هیچ هەلی کارێکت بڵاونەکردووەتەوە</div>
              <p style="font-size:.88rem; margin-top:.4rem; color:var(--txt3);">لەرێگەی فۆڕمەکەی سەرەوە دەتوانیت پێداویستی مامۆستا و کارمەند بۆ دامەزراوەکەت ڕابگەیەنیت.</p>
            </div>
          @endif
        </div>
      </div>
    </div>

    {{-- ══ TAB: SETTINGS ══ --}}
    <div class="db-tab" id="tab-settings">
      <div class="pg-head">
        <div class="pg-title">ڕێکخستنەکان<span>ی هەژمار</span></div>
        <p class="pg-sub">گۆڕینی ناو، ئیمەیڵ و وشەی نهێنی</p>
      </div>

      <div class="db-card">
        <form id="form-settings" method="POST" action="{{ route('portal.settings.save') }}" onsubmit="handleAjaxSubmit(event, 'btn-save-settings')">
          @csrf
          <div class="f-group">
            <label class="f-label">ناوی تەواو <span class="f-req">*</span></label>
            <input type="text" name="name" class="f-input" value="{{ auth()->user()->name }}" required>
          </div>
          <div class="f-group">
            <label class="f-label">ئیمەیڵ <span class="f-req">*</span></label>
            <input type="email" name="email" class="f-input" value="{{ auth()->user()->email }}" dir="ltr" style="text-align: left;" required>
          </div>
          <div class="f-group">
            <label class="f-label">وشەی نهێنی نوێ</label>
            <input type="password" name="password" class="f-input" placeholder="گەر نایگۆڕیت بەتاڵی جێبهێڵە" dir="ltr" style="text-align: left;">
            <div class="f-file-hint" style="margin-top:4px;">لایەنی کەم دەبێت ٨ پیت یان ژمارە بێت</div>
          </div>
          <div style="display:flex;align-items:center;gap:.75rem;margin-top:1.5rem">
            <button type="submit" id="btn-save-settings" class="btn-primary">
              <span class="btn-icon">💾</span> <span>نوێکردنەوەی زانیارییەکان</span>
            </button>
          </div>
        </form>
      </div>
    </div>

    {{-- ══ TAB: NEW POST ══ --}}
    <div class="db-tab" id="tab-new-post">
      <div class="pg-head">
        <div class="pg-title">پۆستی <span>نوێ</span></div>
        <p class="pg-sub">هەواڵ، ئیلان یان بابەتێک بڵاوبکەرەوە</p>
      </div>

      @if(!$institution)
        <div class="nt nt-warn"><span class="nt-icon">⚠</span><span>پێشتر دامەزراوەکەت تۆمار بکە.</span></div>
      @elseif(!$institution->approved)
        <div class="locked-state">
          <div class="locked-icon">🔒</div>
          <div style="font-weight:800;color:var(--txt);margin-bottom:.35rem">دامەزراوەکەت هێشتا قبوڵ نەکراوە</div>
          <div style="font-size:.82rem;color:var(--txt3)">پاش قبوڵکردنی ئەدمین دەتوانیت پۆست بکەیت</div>
        </div>
      @else
        <div class="db-card">
          <form id="form-post" method="POST" action="{{ route('portal.posts.store') }}" enctype="multipart/form-data" onsubmit="handleAjaxSubmit(event, 'btn-save-post')">
            @csrf
            <div class="f-group">
              <label class="f-label">ناونیشانی پۆست <span class="f-req">*</span></label>
              <input type="text" name="title" class="f-input" placeholder="ناونیشانی کورت و ڕوون" value="{{ old('title') }}" required>
            </div>
            <div class="f-group">
              <label class="f-label">ناوەڕۆک <span class="f-req">*</span></label>
              <div id="editor-post" class="quill-editor" style="min-height: 200px;">{!! old('content') !!}</div>
              <textarea id="post-content" name="content" style="display:none;"></textarea>
            </div>
            <div class="f-group">
              <label class="f-label">وێنە (ئەختیاری)</label>
              <label class="f-file" for="post-img">
                <input type="file" id="post-img" name="image" accept="image/*" onchange="previewImg(this,'post-prev')">
                <div class="f-file-icon">🖼</div>
                <div class="f-file-text">وێنەی پۆست هەڵبژێرە</div>
                <div class="f-file-hint">PNG, JPG · max 4MB</div>
              </label>
              <img id="post-prev" class="f-preview" alt="">
            </div>
            <div style="display:flex;align-items:center;gap:.75rem;flex-wrap:wrap;margin-top:.5rem">
              <button type="submit" id="btn-save-post" class="btn-primary">
                <span class="btn-icon">🚀</span> <span>بڵاوکردنەوە</span>
              </button>
              <span style="font-size:.78rem;color:var(--txt3)">ئەدمین پەسەندی دەکات پاش بڵاوکردنەوە</span>
            </div>
          </form>
        </div>
      @endif
    </div>

  </main>
</div>

{{-- ══ MOBILE BOTTOM NAV ══ --}}
<nav class="db-mobile-nav">
  <div class="db-mobile-nav-inner">
    <button class="db-mob-btn is-active" id="mob-institution" onclick="showTab('institution',null);syncMobile('institution')">
      <span class="mob-icon">🏫</span>دامەزراوەکەم
    </button>
    <button class="db-mob-btn" id="mob-posts" onclick="showTab('posts',null);syncMobile('posts')">
      <span class="mob-icon">📰</span>پۆستەکانم
    </button>
    <button class="db-mob-btn" id="mob-reviews" onclick="showTab('reviews',null);syncMobile('reviews')">
      <span class="mob-icon">⭐</span>هەڵسەنگاندن
    </button>
    <button class="db-mob-btn" id="mob-messages" onclick="showTab('messages',null);syncMobile('messages')">
      <span class="mob-icon">💬</span>نامەکان
    </button>
    <button class="db-mob-btn" id="mob-jobs" onclick="showTab('jobs',null);syncMobile('jobs')">
      <span class="mob-icon">💼</span>هەلی کار
    </button>
    <button class="db-mob-btn" id="mob-new-post" onclick="showTab('new-post',null);syncMobile('new-post')">
      <span class="mob-icon">✏️</span>پۆستی نوێ
    </button>
    <form method="POST" action="{{ route('portal.logout') }}" style="display:contents">
      @csrf
      <button type="submit" class="db-mob-btn">
        <span class="mob-icon">🚪</span>دەرچوون
      </button>
    </form>
  </div>
</nav>

@endsection

@section('scripts')
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<style>
  .ql-toolbar.ql-snow {
    border: 1px solid var(--border) !important;
    border-top-left-radius: var(--radius-sm);
    border-top-right-radius: var(--radius-sm);
    background: rgba(15, 22, 36, 0.6);
    direction: ltr; /* Quill toolbar is LTR */
  }
  .ql-container.ql-snow {
    border: 1px solid var(--border) !important;
    border-top: none !important;
    border-bottom-left-radius: var(--radius-sm);
    border-bottom-right-radius: var(--radius-sm);
    background: rgba(6, 10, 18, 0.4);
    font-family: inherit; font-size: .95rem; color: var(--txt);
    min-height: 120px;
  }
  .ql-editor { direction: rtl; text-align: right; }
  .quill-editor[dir="ltr"] .ql-editor { direction: ltr !important; text-align: left !important; }
  .quill-editor:not([dir="ltr"]) .ql-editor ol,
  .quill-editor:not([dir="ltr"]) .ql-editor ul { padding-left: 0; padding-right: 1.5em; }
  .quill-editor:not([dir="ltr"]) .ql-editor li::before { 
      margin-left: 0 !important; 
      margin-right: -1.5em !important; 
      text-align: right !important; 
  }
  .ql-stroke { stroke: var(--txt2) !important; }
  .ql-fill { fill: var(--txt2) !important; }
  .ql-picker-label { color: var(--txt2) !important; }
  .ql-active .ql-stroke { stroke: var(--gold-lt) !important; }
  .ql-active .ql-fill { fill: var(--gold-lt) !important; }
</style>
<script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>

<script>
// Format Currency Inputs
function formatCurrency(val) {
    if (!val) return '';
    const num = val.toString().replace(/[^0-9]/g, '');
    if (!num) return '';
    return Number(num).toLocaleString('en-US');
}

// Transliterate Kurmanji Latin to Arabic Script
function kurmanjiLatinToArabic(text) {
    const map = {
        'A':'ئا','a':'ا', 'B':'ب','b':'ب', 'C':'ج','c':'ج', 'Ç':'چ','ç':'چ',
        'D':'د','d':'د', 'E':'ئە','e':'ە', 'Ê':'ئێ','ê':'ێ', 'F':'ف','f':'ف',
        'G':'گ','g':'گ', 'H':'هـ','h':'هـ', 'I':'','i':'', 'Î':'ئی','î':'ی',
        'J':'ژ','j':'ژ', 'K':'ک','k':'ک', 'L':'ل','l':'ل', 'M':'م','m':'م',
        'N':'ن','n':'ن', 'O':'ئۆ','o':'ۆ', 'P':'پ','p':'پ', 'Q':'ق','q':'ق',
        'R':'ر','r':'ر', 'S':'س','s':'س', 'Ş':'ش','ş':'ش', 'T':'ت','t':'ت',
        'U':'ئو','u':'و', 'Û':'ئوو','û':'وو', 'V':'ڤ','v':'ڤ', 'W':'و','w':'و',
        'X':'خ','x':'خ', 'Y':'ی','y':'ی', 'Z':'ز','z':'ز', ' ': ' ', '-': '-', '.': '.'
    };
    
    let words = text.split(' ');
    for(let i=0; i<words.length; i++) {
        let w = words[i];
        if(!w) continue;
        let c = w[0];
        if(c === 'a' || c === 'A') words[i] = 'ئا' + w.slice(1);
        else if(c === 'e' || c === 'E') words[i] = 'ئە' + w.slice(1);
        else if(c === 'ê' || c === 'Ê') words[i] = 'ئێ' + w.slice(1);
        else if(c === 'î' || c === 'Î') words[i] = 'ئی' + w.slice(1);
        else if(c === 'o' || c === 'O') words[i] = 'ئۆ' + w.slice(1);
        else if(c === 'u' || c === 'U') words[i] = 'ئو' + w.slice(1);
        else if(c === 'û' || c === 'Û') words[i] = 'ئوو' + w.slice(1);
    }
    
    let str = words.join(' ');
    let res = '';
    for(let i=0; i<str.length; i++) {
        res += map[str[i]] !== undefined ? map[str[i]] : str[i];
    }
    return res;
}

function attachCurrencyFormatter() {
    document.querySelectorAll('.currency-input:not(.formatted)').forEach(input => {
        input.classList.add('formatted');
        // Format on load
        input.value = formatCurrency(input.value);
        // Format on input
        input.addEventListener('input', function(e) {
            let start = this.selectionStart;
            let val = this.value;
            let formatted = formatCurrency(val);
            let diff = formatted.length - val.length;
            this.value = formatted;
            this.setSelectionRange(start + diff, start + diff);
        });
    });
}

// Handle Form Submission (Loading State) via AJAX
async function handleAjaxSubmit(e, btnId) {
    e.preventDefault();
    const form = e.target;

    // Sync Quill Editors
    if (quillEditors['desc']) document.getElementById('desc').value = quillEditors['desc'].root.innerHTML;
    if (quillEditors['desc_kbd']) document.getElementById('desc_kbd').value = quillEditors['desc_kbd'].root.innerHTML;
    if (quillEditors['desc_ar']) document.getElementById('desc_ar').value = quillEditors['desc_ar'].root.innerHTML;
    if (quillEditors['desc_en']) document.getElementById('desc_en').value = quillEditors['desc_en'].root.innerHTML;
    if (quillEditors['post'] && document.getElementById('post-content')) document.getElementById('post-content').value = quillEditors['post'].root.innerHTML;

    const btn = document.getElementById(btnId);
    let originalHtml = '';
    if (btn) {
        originalHtml = btn.innerHTML;
        btn.disabled = true;
        btn.classList.add('loading');
        const icon = btn.querySelector('.btn-icon');
        if (icon) icon.style.display = 'none';
        btn.querySelector('span').innerHTML = '⏳ چاوەڕوان بە...';
    }

    try {
        const formData = new FormData(form);
        const res = await fetch(form.action, {
            method: 'POST',
            body: formData,
            headers: { 'Accept': 'application/json' }
        });
        const data = await res.json();
        
        // Clear previous inline errors
        form.querySelectorAll('.ajax-error').forEach(e => e.remove());
        form.querySelectorAll('.has-ajax-error').forEach(e => {
            e.classList.remove('has-ajax-error');
            e.style.borderColor = '';
        });

        if (res.ok) {
            showToast(data.message || 'سەرکەوتوو بوو', 'success');
            if (form.id === 'form-post' || form.id === 'form-settings') {
                setTimeout(() => location.reload(), 1500);
            }
        } else {
            let msg = data.message || 'هەڵەیەک ڕوویدا';
            if (data.errors) {
                const firstKey = Object.keys(data.errors)[0];
                msg = data.errors[firstKey][0];
                
                // Show inline errors
                for (let key in data.errors) {
                    let inputName = key;
                    if (key.includes('.')) {
                        let parts = key.split('.');
                        inputName = parts[0];
                        for(let i=1; i<parts.length; i++) {
                            inputName += `[${parts[i]}]`;
                        }
                    }
                    let inputs = form.querySelectorAll(`[name="${inputName}"]`);
                    inputs.forEach(input => {
                        input.classList.add('has-ajax-error');
                        input.style.borderColor = '#ef4444';
                        let errDiv = document.createElement('div');
                        errDiv.className = 'ajax-error';
                        errDiv.style.cssText = 'color:#ef4444; font-size:.75rem; margin-top:4px;';
                        errDiv.innerText = data.errors[key][0];
                        input.parentNode.insertBefore(errDiv, input.nextSibling);
                    });
                }
            }
            showToast(msg, 'error');
        }
    } catch (err) {
        showToast('هێڵی ئینتەرنێتەکەت کێشەی هەیە یان سێرڤەر وەڵام ناداتەوە', 'error');
    } finally {
        if (btn) {
            btn.disabled = false;
            btn.classList.remove('loading');
            btn.innerHTML = originalHtml;
        }
    }
}

let quillEditors = {};

document.addEventListener('DOMContentLoaded', () => {
    // Initialize Quill
    const toolbarOptions = [
      ['bold', 'italic', 'underline'],
      [{ 'list': 'ordered'}, { 'list': 'bullet' }],
      ['link'],
      ['clean']
    ];
    
    if (document.getElementById('editor-desc')) {
        quillEditors['desc'] = new Quill('#editor-desc', { theme: 'snow', modules: { toolbar: toolbarOptions }});
        quillEditors['desc_kbd'] = new Quill('#editor-desc_kbd', { theme: 'snow', modules: { toolbar: toolbarOptions }});
        quillEditors['desc_ar'] = new Quill('#editor-desc_ar', { theme: 'snow', modules: { toolbar: toolbarOptions }});
        quillEditors['desc_en'] = new Quill('#editor-desc_en', { theme: 'snow', modules: { toolbar: toolbarOptions }});
    }
    if (document.getElementById('editor-post')) {
        quillEditors['post'] = new Quill('#editor-post', { theme: 'snow', modules: { toolbar: toolbarOptions }});
    }

    attachCurrencyFormatter();

    // Restore active tab
    const activeTab = localStorage.getItem('db_active_tab') || 'institution';
    const activeBtn = document.querySelector(`[onclick="showTab('${activeTab}', this)"]`);
    if (activeBtn) activeBtn.click();
    else showTab('institution', document.querySelector('.db-nav-btn'));
});

function showTab(name, sideBtn) {
    document.querySelectorAll('.db-tab').forEach(p => p.classList.remove('is-active'));
    document.querySelectorAll('.db-nav-btn').forEach(b => b.classList.remove('is-active'));
    const tab = document.getElementById('tab-' + name);
    if(tab) tab.classList.add('is-active');
    if (sideBtn) {
        sideBtn.classList.add('is-active');
    } else {
        const btn = document.querySelector(`.db-nav-btn[data-tab="${name}"]`) || document.querySelector(`[onclick*="'${name}'"]`);
        if (btn) btn.classList.add('is-active');
    }
    syncMobile(name);
    localStorage.setItem('db_active_tab', name);
}
function syncMobile(name) {
    document.querySelectorAll('.db-mob-btn').forEach(b => b.classList.remove('is-active'));
    const mob = document.getElementById('mob-' + name);
    if (mob) mob.classList.add('is-active');
}
function previewImg(input, previewId) {
    const file = input.files[0];
    if (!file) return;
    if (file.size > 10 * 1024 * 1024) {
        if(typeof showToast === 'function') showToast('گەورەترین قەبارەی ڕێگەپێدراو 10 مێگابایتە', 'error');
        else alert('گەورەترین قەبارەی ڕێگەپێدراو 10 مێگابایتە');
        input.value = '';
        return;
    }
    const reader = new FileReader();
    reader.onload = e => {
        const img = document.getElementById(previewId);
        if (img) { img.src = e.target.result; img.style.display = 'block'; }
        if(input.id === 'logo-input' && document.getElementById('logo-wrapper')) document.getElementById('logo-wrapper').style.display = 'inline-block';
        if(input.id === 'img-input' && document.getElementById('img-wrapper')) document.getElementById('img-wrapper').style.display = 'inline-block';
    };
    reader.readAsDataURL(file);
}
async function translateDeptNames(btn) {
    const section = document.getElementById('academic-section');
    const isCollege = document.getElementById('group-colleges').style.display !== 'none';
    let inputs = [];
    if (isCollege) {
        section.querySelectorAll('.college-card .clg-name').forEach(i => inputs.push(i));
        section.querySelectorAll('.college-card .dept-row .tr-input').forEach(i => inputs.push(i));
    } else {
        section.querySelectorAll('#depts-list .fee-row .tr-input').forEach(i => inputs.push(i));
    }
    inputs = inputs.filter(i => i.value.trim());
    if (!inputs.length) { alert('تکایە سەرەتا ناوی بەشەکان بنووسە.'); return; }
    if (btn) { btn.classList.add('loading'); btn.disabled = true; }
    try {
        for (const inp of inputs) {
            const text = inp.value.trim();
            if (!text) continue;
            let hint = inp.nextElementSibling;
            if (!hint || !hint.classList.contains('tr-hint')) {
                hint = document.createElement('small');
                hint.className = 'tr-hint';
                hint.style.cssText = 'display:block;font-size:.68rem;color:var(--txt3);margin-top:3px;direction:rtl;line-height:1.7';
                inp.after(hint);
            }

            // Create hidden inputs for translation
            const nameEn = inp.name.replace('[name]', '[name_en]').replace('simple_dept[]', 'simple_dept_en[]');
            const nameAr = inp.name.replace('[name]', '[name_ar]').replace('simple_dept[]', 'simple_dept_ar[]');
            const nameKbd = inp.name.replace('[name]', '[name_kbd]').replace('simple_dept[]', 'simple_dept_kbd[]');
            
            // Remove old hidden inputs if any
            const parent = inp.parentElement;
            parent.querySelectorAll(`input[name="${nameEn}"], input[name="${nameAr}"], input[name="${nameKbd}"]`).forEach(e => e.remove());

            hint.textContent = '⏳ وەرگێران...';
            const [arRes, enRes, kbdRes] = await Promise.all([
                fetch(`https://translate.googleapis.com/translate_a/single?client=gtx&sl=ckb&tl=ar&dt=t&q=${encodeURIComponent(text)}`).then(r => r.json()),
                fetch(`https://translate.googleapis.com/translate_a/single?client=gtx&sl=ckb&tl=en&dt=t&q=${encodeURIComponent(text)}`).then(r => r.json()),
                fetch(`https://translate.googleapis.com/translate_a/single?client=gtx&sl=ckb&tl=ku&dt=t&q=${encodeURIComponent(text)}`).then(r => r.json()),
            ]);
            const ar = arRes?.[0]?.map(p => p[0] ?? '').join('') ?? '';
            const en = enRes?.[0]?.map(p => p[0] ?? '').join('') ?? '';
            let kbd = kbdRes?.[0]?.map(p => p[0] ?? '').join('') ?? '';
            kbd = kurmanjiLatinToArabic(kbd);
            
            hint.innerHTML = `<span style="color:var(--gold);font-weight:800">AR</span> ${ar}&nbsp;&nbsp;<span style="color:var(--gold);font-weight:800">EN</span> ${en}&nbsp;&nbsp;<span style="color:var(--gold);font-weight:800">KBD</span> ${kbd}`;

            // Add hidden inputs
            const hEn = document.createElement('input'); hEn.type = 'hidden'; hEn.name = nameEn; hEn.value = en;
            const hAr = document.createElement('input'); hAr.type = 'hidden'; hAr.name = nameAr; hAr.value = ar;
            const hKbd = document.createElement('input'); hKbd.type = 'hidden'; hKbd.name = nameKbd; hKbd.value = kbd;
            parent.appendChild(hEn);
            parent.appendChild(hAr);
            parent.appendChild(hKbd);
        }
    } catch { alert('هەڵەیەک ڕوویدا لە کاتی وەرگێڕان.'); }
    finally { if (btn) { btn.classList.remove('loading'); btn.disabled = false; } }
}
async function autoTranslate(sourceId, targetIds, btn) {
    let text = document.getElementById(sourceId).value;
    if (quillEditors[sourceId]) {
        text = quillEditors[sourceId].getText().trim();
    }
    if (!text) { alert('تکایە سەرەتا دەقەکە بنووسە.'); return; }
    if (btn) { btn.classList.add('loading'); btn.disabled = true; }
    // Map target field IDs to Google Translate language codes
    const langMap = { 'desc_kbd': 'ku', 'desc_ar': 'ar', 'desc_en': 'en', 'nkbd': 'ku', 'nar': 'ar', 'nen': 'en' };
    try {
        for (const targetId of targetIds) {
            const lang = langMap[targetId] ?? (targetId.includes('ar') ? 'ar' : targetId.includes('en') ? 'en' : 'ku');
            const url  = `https://translate.googleapis.com/translate_a/single?client=gtx&sl=ckb&tl=${lang}&dt=t&q=${encodeURIComponent(text)}`;
            const data = await (await fetch(url)).json();
            if (data?.[0]) {
                let translated = data[0].map(p => p[0] ?? '').join('');
                
                // If it's a Badini field and we used 'ku' (which returns Latin script), transliterate to Arabic script
                if ((targetId === 'desc_kbd' || targetId === 'nkbd') && lang === 'ku') {
                    translated = kurmanjiLatinToArabic(translated);
                }

                if (quillEditors[targetId]) {
                    quillEditors[targetId].root.innerHTML = translated;
                } else {
                    document.getElementById(targetId).value = translated;
                }
            }
        }
    } catch { alert('هەڵەیەک ڕوویدا لە کاتی وەرگێڕان.'); }
    finally { if (btn) { btn.classList.remove('loading'); btn.disabled = false; } }
}

let isTranslatedAll = false;
async function translateAll() {
    const btn = document.getElementById('btn-translate-all');
    const originalText = btn.innerHTML;
    btn.innerHTML = '<span>⏳</span> <span>لە پرۆسەدایە... تکایە چاوەڕێبە</span>';
    btn.disabled = true;
    
    try {
        // Translate Name
        if (document.getElementById('nku').value.trim()) {
            await autoTranslate('nku', ['nkbd', 'nar', 'nen'], null);
        }
        // Translate Description
        if (document.getElementById('desc').value.trim() || (quillEditors['desc'] && quillEditors['desc'].getText().trim())) {
            await autoTranslate('desc', ['desc_kbd', 'desc_ar', 'desc_en'], null);
        }
        // Translate Departments
        if (document.getElementById('academic-section').style.display !== 'none') {
            await translateDeptNames(null);
        }
        isTranslatedAll = true;
        btn.innerHTML = '<span>✅</span> <span>وەرگێڕانی گشتی تەواو بوو</span>';
        btn.disabled = false;
        btn.style.opacity = '1';
        btn.style.cursor = 'pointer';
    } catch (e) {
        alert('هەڵەیەک ڕوویدا. تکایە دووبارە هەوڵبدەرەوە.');
        btn.innerHTML = originalText;
        btn.disabled = false;
    }
}

const originalHandleAjaxSubmit = window.handleAjaxSubmit;
window.handleAjaxSubmit = function(e, btnId) {
    if (originalHandleAjaxSubmit) {
        return originalHandleAjaxSubmit(e, btnId);
    }
}
const TYPE_FLAGS = @json($typeFlags);
function handleTypeChange(type) {
    const section  = document.getElementById('academic-section');
    const grpCol   = document.getElementById('group-colleges');
    const grpDept  = document.getElementById('group-depts');
    const title    = document.getElementById('academic-title');
    const flags    = TYPE_FLAGS[type] || { has_colleges: false, has_departments: false };
    if (!flags.has_colleges && !flags.has_departments) {
        section.style.display = 'none'; return;
    }
    section.style.display = '';
    title.textContent     = flags.has_colleges ? 'کۆلێژ و بەشەکان' : 'بەشەکان و پارەدان';
    grpCol.style.display  = flags.has_colleges ? '' : 'none';
    grpDept.style.display = (!flags.has_colleges && flags.has_departments) ? '' : 'none';

    if (['gov', 'inst5', 'inst2'].includes(type)) {
        section.classList.add('hide-fees');
        // Clear fee/discount inputs so they do not submit stale values
        section.querySelectorAll('.dept-row input:nth-child(2), .dept-row input:nth-child(3), .fee-row input:nth-child(2), .fee-row input:nth-child(3)').forEach(inp => {
            inp.value = '';
        });
    } else {
        section.classList.remove('hide-fees');
    }
}
let _nextCi = {{ $nextCiSeed ?? 1 }};
function addCollege() {
    const container = document.getElementById('colleges-container');
    const ci = _nextCi++;
    const card = document.createElement('div');
    card.className = 'college-card';
    card.dataset.ci = ci;
    card.innerHTML =
        `<div class="college-header">` +
          `<span class="college-badge">کۆلێژ</span>` +
          `<input type="text" name="clg[${ci}][name]" class="f-input clg-name" placeholder="بۆ نموونە: کۆلێژی ئەندازیاری">` +
          `<button type="button" class="college-del-btn" onclick="removeCollege(this)">✕</button>` +
        `</div>` +
        `<div class="college-body">` +
          `<div class="depts-header-row">` +
            `<span class="depts-header-label">بەشەکان</span>` +
            `<span class="depts-header-line"></span>` +
          `</div>` +
          `<div class="dept-col-labels">` +
            `<span>ناوی بەش</span><span>پارە (دینار)</span><span>داشکان %</span><span></span>` +
          `</div>` +
          `<div class="depts-wrap">` +
            `<div class="dept-row">` +
              `<div style="display:flex; flex-direction:column; min-width:0;">` +
                `<input type="text" name="clg[${ci}][depts][0][name]" class="f-input tr-input" placeholder="بۆ نموونە: بەشی کۆمپیوتەر">` +
              `</div>` +
              `<input type="text" name="clg[${ci}][depts][0][fee]" class="f-input currency-input" placeholder="پارە (150,000)">` +
              `<input type="text" name="clg[${ci}][depts][0][discount]" class="f-input" placeholder="داشکان (10%)">` +
              `<button type="button" class="dept-del-btn" onclick="removeDept(this)">✕</button>` +
            `</div>` +
          `</div>` +
          `<button type="button" class="add-dept-btn" onclick="addDept(this)">＋ بەش زیاد بکە</button>` +
        `</div>`;
    container.appendChild(card);
    attachCurrencyFormatter();
    card.querySelector('input').focus();
}
function removeCollege(btn) {
    const card = btn.closest('.college-card');
    if (card.parentElement.children.length > 1) card.remove();
    else card.querySelectorAll('input').forEach(i => i.value = '');
}
function addDept(btn) {
    const card = btn.closest('.college-card');
    const ci   = card.dataset.ci;
    const wrap = card.querySelector('.depts-wrap');
    const di   = wrap.children.length;
    const row  = document.createElement('div');
    row.className = 'dept-row';
    row.innerHTML =
        `<div style="display:flex; flex-direction:column; min-width:0;">` +
          `<input type="text" name="clg[${ci}][depts][${di}][name]" class="f-input tr-input" placeholder="بۆ نموونە: بەشی کۆمپیوتەر">` +
        `</div>` +
        `<input type="text" name="clg[${ci}][depts][${di}][fee]" class="f-input currency-input" placeholder="پارە (150,000)">` +
        `<input type="text" name="clg[${ci}][depts][${di}][discount]" class="f-input" placeholder="داشکان (10%)">` +
        `<button type="button" class="dept-del-btn" onclick="removeDept(this)">✕</button>`;
    wrap.appendChild(row);
    attachCurrencyFormatter();
    row.querySelector('input').focus();
}
function removeDept(btn) {
    const row = btn.parentElement;
    if (row.parentElement.children.length > 1) row.remove();
    else row.querySelectorAll('input').forEach(i => i.value = '');
}
function addSimpleDeptRow() {
    const list = document.getElementById('depts-list');
    const row  = document.createElement('div');
    row.className = 'fee-row';
    row.innerHTML =
        `<div style="display:flex; flex-direction:column; min-width:0;">` +
          `<input type="text" name="simple_dept[]" class="f-input tr-input" placeholder="بۆ نموونە: بەشی کۆمپیوتەر">` +
        `</div>` +
        `<input type="text" name="simple_fee[]" class="f-input currency-input" placeholder="پارە (150,000)">` +
        `<input type="text" name="simple_discount[]" class="f-input" placeholder="داشکان (10%)">` +
        `<button type="button" class="dept-del-btn" onclick="removeRow(this)">✕</button>`;
    list.appendChild(row);
    attachCurrencyFormatter();
    row.querySelector('input').focus();
}
function removeRow(btn) {
    const row  = btn.parentElement;
    const list = row.parentElement;
    if (list.children.length > 1) row.remove();
    else row.querySelectorAll('input').forEach(i => i.value = '');
}
function formatShortAddress(data) {
    if (!data || !data.address) return data.display_name || '';
    const addr = data.address;
    const parts = [];
    
    // 1. Street or neighbourhood/suburb
    const local = addr.road || addr.suburb || addr.neighbourhood || addr.quarter || addr.residential || addr.industrial;
    if (local) parts.push(local);
    
    // 2. City or Town
    const city = addr.city || addr.town || addr.village || addr.municipality || addr.county;
    if (city && city !== local) parts.push(city);
    
    // 3. State/Region or Country
    const region = addr.state || addr.country;
    if (region && region !== city) parts.push(region);
    
    return parts.length > 0 ? parts.join(', ') : (data.display_name || '');
}
function handleAddrInput(value) {
    if (!value) {
        document.getElementById('lat-input').value = '';
        document.getElementById('lng-input').value = '';
        document.getElementById('map-feedback').style.display = 'none';
        return;
    }
    const regex = /(-?\d+\.\d+)\s*,\s*(-?\d+\.\d+)/;
    const match = value.match(regex);
    if (match) {
        const lat = match[1];
        const lng = match[2];
        document.getElementById('lat-input').value = lat;
        document.getElementById('lng-input').value = lng;
        const fb = document.getElementById('map-feedback');
        fb.style.display = 'block';
        fb.textContent = '✓ کۆۆردیناتەکان دۆزرانەوە، ئێستا ناونیشانی دەقی وەردەگیرێت...';
        fb.style.color = '#3b82f6';
        
        const addrField = document.getElementById('addr-input');
        fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}&accept-language=ku,ar,en`)
            .then(response => response.json())
            .then(data => {
                const shortAddr = formatShortAddress(data);
                if (shortAddr) {
                    addrField.value = shortAddr;
                    fb.textContent = '✓ کۆۆردینات و ناونیشان بە سەرکەوتوویی وەرگیران!';
                    fb.style.color = '#22c55e';
                }
            })
            .catch(err => {
                fb.textContent = '✓ کۆۆردیناتەکان بە سەرکەوتوویی پارێزراون.';
                fb.style.color = '#22c55e';
            });
    } else {
        document.getElementById('map-feedback').style.display = 'none';
    }
}
function getCurrentLocation(btn) {
    if (!navigator.geolocation) {
        alert('مۆبایلەکەت یان گەڕانکارەکەت پشتگیری وەرگرتنی شوێن ناکات.');
        return;
    }
    const originalText = btn.innerHTML;
    btn.innerHTML = '⏳ لە پرۆسەدایە...';
    btn.disabled = true;
    
    const addrField = document.getElementById('addr-input');
    addrField.placeholder = '⏳ بەدەستهێنانی ناونیشانی دەقی لە نەخشەوە...';
    
    navigator.geolocation.getCurrentPosition(
        (position) => {
            const lat = position.coords.latitude.toFixed(6);
            const lng = position.coords.longitude.toFixed(6);
            document.getElementById('lat-input').value = lat;
            document.getElementById('lng-input').value = lng;
            
            const fb = document.getElementById('map-feedback');
            fb.style.display = 'block';
            fb.textContent = '✓ کۆۆردینات بە سەرکەوتوویی وەرگیرا. ئێستا ناونیشانی دەقی وەردەگیرێت...';
            fb.style.color = '#3b82f6';
            
            fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}&accept-language=ku,ar,en`)
                .then(response => response.json())
                .then(data => {
                    const shortAddr = formatShortAddress(data);
                    if (shortAddr) {
                        addrField.value = shortAddr;
                        fb.textContent = '✓ شوێن و ناونیشانی دەقیت بە سەرکەوتوویی وەرگیرا لە نەخشەوە!';
                        fb.style.color = '#22c55e';
                    } else {
                        fb.textContent = '✓ کۆۆردینات وەرگیرا، بەڵام نەتوانرا ناونیشانی دەقی دیاری بکرێت.';
                        fb.style.color = '#ff9f43';
                    }
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                    addrField.placeholder = 'ناونیشانی تەواو بنووسە یان بەستەری نەخشە دابنێ...';
                })
                .catch(err => {
                    fb.textContent = '✓ کۆۆردینات وەرگیرا، بەڵام پەیوەندی بە نەخشەوە نەکرا بۆ وەرگرتنی ناونیشانی دەقی.';
                    fb.style.color = '#ff9f43';
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                    addrField.placeholder = 'ناونیشانی تەواو بنووسە یان بەستەری نەخشە دابنێ...';
                });
        },
        (error) => {
            let msg = 'نەتوانرا شوێنەکەت دیاری بکرێت.';
            if (error.code === error.PERMISSION_DENIED) {
                msg = 'تکایە ڕێگەبدە بە بەکارهێنانی لۆکەیشن بۆ ئەم ماڵپەڕە تاوەکو شوێنەکەت وەربگیرێت.';
            }
            alert(msg);
            addrField.placeholder = 'ناونیشانی تەواو بنووسە یان بەستەری نەخشە دابنێ...';
            btn.innerHTML = originalText;
            btn.disabled = false;
        },
        { enableHighAccuracy: false, timeout: 25000, maximumAge: 60000 }
    );
}

// ── Google Maps Portal Picker ──────────────────────────────────────────────
let _portalMapLoaded = false;
let _portalMapOpen   = false;

function togglePortalMap() {
    const container = document.getElementById('portal-map-container');
    const btn       = document.getElementById('toggle-map-btn');
    _portalMapOpen  = !_portalMapOpen;

    container.style.display = _portalMapOpen ? 'block' : 'none';
    btn.innerHTML = _portalMapOpen
        ? '🗺️ داخستنی نەقشە'
        : '🗺️ نەقشە بکەرەوە بۆ دیاریکردنی شوێن';

    if (_portalMapOpen && !_portalMapLoaded) {
        _portalMapLoaded = true;
        const s   = document.createElement('script');
        s.src     = 'https://maps.googleapis.com/maps/api/js?key=AIzaSyAZbZwzBVGQPPJ930JbhdwRwWH4q-yDRsA&callback=initPortalMap';
        s.async   = true;
        window.initPortalMap = _initPortalMap;
        document.head.appendChild(s);
    }
}

function _initPortalMap() {
    const latVal = parseFloat(document.getElementById('lat-input').value) || 36.1901;
    const lngVal = parseFloat(document.getElementById('lng-input').value) || 44.0090;
    const hasPin = document.getElementById('lat-input').value !== '';

    const map = new google.maps.Map(document.getElementById('portal-map-picker'), {
        center: { lat: latVal, lng: lngVal },
        zoom: hasPin ? 15 : 12,
        mapTypeControl: false,
        streetViewControl: false,
        fullscreenControl: false,
    });

    let marker = null;

    if (hasPin) {
        marker = new google.maps.Marker({ position: { lat: latVal, lng: lngVal }, map, draggable: true });
        marker.addListener('dragend', e => _updatePortalCoords(e.latLng.lat(), e.latLng.lng()));
    }

    map.addListener('click', e => {
        const lat = e.latLng.lat();
        const lng = e.latLng.lng();
        _updatePortalCoords(lat, lng);
        if (marker) {
            marker.setPosition(e.latLng);
        } else {
            marker = new google.maps.Marker({ position: e.latLng, map, draggable: true });
            marker.addListener('dragend', ev => _updatePortalCoords(ev.latLng.lat(), ev.latLng.lng()));
        }
    });
}

function _updatePortalCoords(lat, lng) {
    document.getElementById('lat-input').value = lat.toFixed(7);
    document.getElementById('lng-input').value = lng.toFixed(7);

    const fb = document.getElementById('map-feedback');
    fb.style.display = 'block';
    fb.style.color   = '#22c55e';
    fb.textContent   = '✓ شوێن لەسەر نەقشە دیاریکرا — کۆۆردینات خەزنکرا';

    // Reverse geocode to fill address
    fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lng}&accept-language=ku,ar,en`)
        .then(r => r.json())
        .then(data => {
            const addr = formatShortAddress(data);
            if (addr) document.getElementById('addr-input').value = addr;
        })
        .catch(() => {});
}

// ════════════════════════════════════════════════
//   PORTAL LIVE CHAT SYSTEM
// ════════════════════════════════════════════════
let currentActiveConvId = null;

function filterChatList(query) {
    const q = query.trim().toLowerCase();
    document.querySelectorAll('#chat-convs-list .chat-conv-item').forEach(item => {
        const name = item.querySelector('.chat-conv-name')?.textContent.toLowerCase() || '';
        const snippet = item.querySelector('.chat-conv-snippet')?.textContent.toLowerCase() || '';
        if (!q || name.includes(q) || snippet.includes(q)) {
            item.style.display = 'flex';
        } else {
            item.style.display = 'none';
        }
    });
}

function selectConversation(convId, userName, userMeta) {
    currentActiveConvId = convId;

    // Highlight item
    document.querySelectorAll('.chat-conv-item').forEach(i => i.classList.remove('is-active'));
    const activeItem = document.getElementById('conv-item-' + convId);
    if (activeItem) activeItem.classList.add('is-active');

    // Hide badge
    const badge = document.getElementById('conv-badge-' + convId);
    if (badge) badge.style.display = 'none';

    // Show header & input
    document.getElementById('chat-box-head').style.display = 'flex';
    document.getElementById('chat-send-form').style.display = 'flex';
    document.getElementById('active-chat-name').textContent = userName || 'بەکارهێنەر';
    document.getElementById('active-chat-meta').textContent = userMeta ? `${userMeta} • لە ئەپڵیکەیشنەوە` : 'لە ئەپڵیکەیشنەوە';
    document.getElementById('active-chat-avatar').textContent = (userName || 'ق').substring(0, 1);

    // Mobile responsive switch
    if (window.innerWidth <= 860) {
        const listPane = document.getElementById('chat-list-pane');
        const boxPane = document.getElementById('chat-box-pane');
        if (listPane) listPane.classList.add('mob-hide');
        if (boxPane) boxPane.classList.remove('mob-hide');
    }

    loadConversationMessages(convId, true);
}

function backToConvsList() {
    if (window.innerWidth <= 860) {
        const listPane = document.getElementById('chat-list-pane');
        const boxPane = document.getElementById('chat-box-pane');
        if (listPane) listPane.classList.remove('mob-hide');
        if (boxPane) boxPane.classList.add('mob-hide');
    }
}

function loadConversationMessages(convId, scrollToBottom = false) {
    if (!convId) return;

    fetch(`/portal/chats/${convId}/messages`, {
        headers: { 'Accept': 'application/json', 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(r => r.json())
    .then(res => {
        if (!res.success) return;
        renderMessages(res.messages, scrollToBottom);
    })
    .catch(err => console.error('Error loading chat messages:', err));
}

function renderMessages(messages, forceScroll = false) {
    const container = document.getElementById('chat-messages-scroll');
    if (!container) return;

    if (!messages || messages.length === 0) {
        container.innerHTML = `
            <div class="chat-empty-box">
                <div style="font-size: 2.2rem; margin-bottom: .5rem; opacity: .4;">💬</div>
                <div>هێشتا هیچ نامەیەک ئاڵوگۆڕ نەکراوە. یەکەم نامە بنووسە.</div>
            </div>
        `;
        return;
    }

    let html = '';
    messages.forEach(m => {
        const isInst = m.sender_type === 'institution';
        const typeClass = isInst ? 'outgoing' : 'incoming';
        const timeStr = m.created_at ? new Date(m.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : '';

        let contentHtml = '';
        if (m.image) {
            contentHtml += `<a href="${m.image}" target="_blank" rel="noopener"><img src="${m.image}" class="chat-img-thumb" alt="وێنە" /></a>`;
        }
        if (m.message) {
            contentHtml += `<div>${escapeHtml(m.message)}</div>`;
        }

        html += `
            <div class="chat-bubble-wrap ${typeClass}">
                <div class="chat-bubble ${typeClass}">
                    ${contentHtml}
                </div>
                <div class="chat-bubble-time">${timeStr} ${isInst ? '✓' : ''}</div>
            </div>
        `;
    });

    const isNearBottom = container.scrollHeight - container.scrollTop - container.clientHeight < 120;
    container.innerHTML = html;

    if (forceScroll || isNearBottom) {
        container.scrollTop = container.scrollHeight;
    }
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

let selectedChatFile = null;

function handleChatImageSelect(input) {
    if (input.files && input.files[0]) {
        selectedChatFile = input.files[0];
        const previewWrap = document.getElementById('chat-selected-img-preview');
        const imgTag = document.getElementById('chat-preview-img-tag');
        const fname = document.getElementById('chat-preview-filename');
        
        imgTag.src = URL.createObjectURL(selectedChatFile);
        fname.textContent = selectedChatFile.name;
        previewWrap.style.display = 'flex';
    }
}

function clearSelectedChatImage() {
    selectedChatFile = null;
    const input = document.getElementById('chat-reply-image');
    if (input) input.value = '';
    const previewWrap = document.getElementById('chat-selected-img-preview');
    if (previewWrap) previewWrap.style.display = 'none';
    const imgTag = document.getElementById('chat-preview-img-tag');
    if (imgTag) imgTag.src = '';
}

function sendChatReply(e) {
    e.preventDefault();
    if (!currentActiveConvId) return;

    const input = document.getElementById('chat-reply-input');
    const msg = input.value.trim();
    const hasImage = !!selectedChatFile;
    if (!msg && !hasImage) return;

    const btn = document.getElementById('btn-chat-send');
    btn.disabled = true;

    const formData = new FormData();
    if (msg) formData.append('message', msg);
    if (hasImage) formData.append('image', selectedChatFile);

    const imageObjUrl = hasImage ? URL.createObjectURL(selectedChatFile) : null;
    input.value = '';
    clearSelectedChatImage();

    // Append visually right away
    const container = document.getElementById('chat-messages-scroll');
    const nowTime = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    const tempBubble = document.createElement('div');
    tempBubble.className = 'chat-bubble-wrap outgoing';

    let tempContent = '';
    if (imageObjUrl) {
        tempContent += `<img src="${imageObjUrl}" class="chat-img-thumb" alt="وێنە" />`;
    }
    if (msg) {
        tempContent += `<div>${escapeHtml(msg)}</div>`;
    }

    tempBubble.innerHTML = `
        <div class="chat-bubble outgoing">${tempContent}</div>
        <div class="chat-bubble-time">${nowTime} ...</div>
    `;
    container.appendChild(tempBubble);
    container.scrollTop = container.scrollHeight;

    // Update snippet in list
    const snippetEl = document.getElementById('conv-snippet-' + currentActiveConvId);
    if (snippetEl) snippetEl.textContent = msg || '📷 وێنە';

    fetch(`/portal/chats/${currentActiveConvId}/reply`, {
        method: 'POST',
        headers: {
            'Accept': 'application/json',
            'X-CSRF-TOKEN': '{{ csrf_token() }}',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData
    })
    .then(r => r.json())
    .then(res => {
        btn.disabled = false;
        if (res.success) {
            tempBubble.querySelector('.chat-bubble-time').textContent = nowTime + ' ✓';
            loadConversationMessages(currentActiveConvId, false);
        }
    })
    .catch(err => {
        btn.disabled = false;
        console.error('Error sending reply:', err);
    });
}

// Background auto-refresh every 3.5s for live chat
setInterval(() => {
    const messagesTab = document.getElementById('tab-messages');
    if (messagesTab && messagesTab.classList.contains('is-active')) {
        if (currentActiveConvId) {
            loadConversationMessages(currentActiveConvId, false);
        }
    }

    // Refresh unread counter and conversation snippets
    fetch('/portal/chats', {
        headers: { 'Accept': 'application/json', 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(r => r.json())
    .then(res => {
        if (!res.success) return;
        const navBadge = document.getElementById('nav-unread-badge');
        if (navBadge) {
            if (res.unread > 0) {
                navBadge.textContent = res.unread;
                navBadge.style.display = 'inline-block';
            } else {
                navBadge.style.display = 'none';
            }
        }
        // Update conv list snippets & unread counts
        if (res.conversations) {
            res.conversations.forEach(c => {
                const s = document.getElementById('conv-snippet-' + c.id);
                if (s && c.last_message) s.textContent = c.last_message;
                const b = document.getElementById('conv-badge-' + c.id);
                if (b) {
                    if (c.institution_unread_count > 0 && currentActiveConvId != c.id) {
                        b.textContent = c.institution_unread_count;
                        b.style.display = 'inline-block';
                    } else {
                        b.style.display = 'none';
                    }
                }
            });
        }
    })
    .catch(err => console.error('Error fetching chats:', err));
}, 3500);

// ── Jobs Management ──
function toggleJobCategoryOther(sel) {
    const other = document.getElementById('job-category-other');
    if (!other) return;
    if (sel.value === 'other') {
        other.style.display = 'block';
        other.required = true;
        other.focus();
    } else {
        other.style.display = 'none';
        other.required = false;
        other.value = '';
    }
}

async function translateJobTitle(btn) {
    const text = document.getElementById('job-title-ku')?.value?.trim();
    if (!text) { alert('تکایە سەرەتا ناونیشانی کار بنووسە.'); return; }
    const hint = document.getElementById('job-title-tr-hint');
    const origText = btn.textContent;
    btn.textContent = '⏳';
    btn.disabled = true;
    hint.style.display = 'block';
    hint.textContent = 'وەرگێران...';
    try {
        const [arRes, enRes, kbdRes] = await Promise.all([
            fetch(`https://translate.googleapis.com/translate_a/single?client=gtx&sl=ckb&tl=ar&dt=t&q=${encodeURIComponent(text)}`).then(r => r.json()),
            fetch(`https://translate.googleapis.com/translate_a/single?client=gtx&sl=ckb&tl=en&dt=t&q=${encodeURIComponent(text)}`).then(r => r.json()),
            fetch(`https://translate.googleapis.com/translate_a/single?client=gtx&sl=ckb&tl=ku&dt=t&q=${encodeURIComponent(text)}`).then(r => r.json()),
        ]);
        const ar  = arRes?.[0]?.map(p => p[0] ?? '').join('') ?? '';
        const en  = enRes?.[0]?.map(p => p[0] ?? '').join('') ?? '';
        let   kbd = kbdRes?.[0]?.map(p => p[0] ?? '').join('') ?? '';
        kbd = kurmanjiLatinToArabic(kbd);
        document.getElementById('job-title-ar').value  = ar;
        document.getElementById('job-title-en').value  = en;
        document.getElementById('job-title-kbd').value = kbd;
        hint.innerHTML = `<span style="color:var(--gold);font-weight:800">AR</span> ${ar}&nbsp;&nbsp;<span style="color:var(--gold);font-weight:800">EN</span> ${en}&nbsp;&nbsp;<span style="color:var(--gold);font-weight:800">KBD</span> ${kbd}`;
        btn.textContent = '✅';
        setTimeout(() => { btn.textContent = origText; btn.disabled = false; }, 2000);
    } catch {
        alert('هەڵەیەک ڕوویدا لە کاتی وەرگێڕان.');
        btn.textContent = origText;
        btn.disabled = false;
        hint.style.display = 'none';
    }
}

const defaultInstData = {
    phone: @json($institution->phone ?? ''),
    wa: @json($institution->wa ?? ''),
    email: @json($institution->email ?? ''),
    city: @json($institution->city ?? 'هەولێر')
};

function editPortalJob(job) {
    if (!job) return;
    document.getElementById('job-edit-id').value = job.id;
    document.getElementById('job-title-ku').value = job.title || '';
    
    const catSelect = document.getElementById('job-category-select');
    const catOther = document.getElementById('job-category-other');
    if (['teacher', 'admin', 'support'].includes(job.category)) {
        catSelect.value = job.category;
        catOther.style.display = 'none';
        catOther.value = '';
    } else {
        catSelect.value = 'other';
        catOther.style.display = 'block';
        catOther.value = job.category || '';
    }

    document.getElementById('job-subject').value = job.subject || '';
    document.getElementById('job-edu-level').value = job.education_level || '';
    document.getElementById('job-emp-type').value = job.employment_type || 'full_time';
    document.getElementById('job-gender').value = job.gender || 'any';
    document.getElementById('job-exp').value = job.experience_years || '';
    document.getElementById('job-salary').value = job.salary_range || '';
    document.getElementById('job-desc').value = job.description || '';
    document.getElementById('job-req').value = job.requirements || '';
    document.getElementById('job-city').value = job.city || defaultInstData.city;
    document.getElementById('job-phone').value = job.contact_phone || defaultInstData.phone;
    document.getElementById('job-wa').value = job.contact_whatsapp || defaultInstData.wa;
    document.getElementById('job-email').value = job.contact_email || defaultInstData.email;

    const submitText = document.getElementById('btn-job-submit-text');
    if (submitText) submitText.textContent = 'نوێکردنەوەی هەلی کار';

    const cancelBtn = document.getElementById('btn-cancel-job-edit');
    if (cancelBtn) cancelBtn.style.display = 'inline-block';

    const hint = document.getElementById('job-form-hint');
    if (hint) hint.textContent = 'لە ئێستادا سەرقاڵی دەستکاریکردنی هەلی کارەکەی';

    document.getElementById('portal-job-form').scrollIntoView({ behavior: 'smooth', block: 'start' });
}

function resetJobForm() {
    const form = document.getElementById('portal-job-form');
    if (form) form.reset();

    document.getElementById('job-edit-id').value = '';
    const other = document.getElementById('job-category-other');
    if (other) { other.style.display = 'none'; other.value = ''; }

    const trHint = document.getElementById('job-title-tr-hint');
    if (trHint) trHint.style.display = 'none';

    document.getElementById('job-city').value = defaultInstData.city;
    document.getElementById('job-phone').value = defaultInstData.phone;
    document.getElementById('job-wa').value = defaultInstData.wa;
    document.getElementById('job-email').value = defaultInstData.email;

    const submitText = document.getElementById('btn-job-submit-text');
    if (submitText) submitText.textContent = 'بڵاوکردنەوەی هەلی کار';

    const cancelBtn = document.getElementById('btn-cancel-job-edit');
    if (cancelBtn) cancelBtn.style.display = 'none';

    const hint = document.getElementById('job-form-hint');
    if (hint) hint.textContent = 'هەلی کارەکە دەستبەجێ لە ئەپڵیکەیشن بڵاودەبێتەوە';
}

async function submitPortalJob(e) {
    e.preventDefault();
    const btn = document.getElementById('btn-save-job');
    const submitText = document.getElementById('btn-job-submit-text');
    const editId = document.getElementById('job-edit-id')?.value;

    let origText = submitText ? submitText.textContent : '';
    if (btn) {
        btn.disabled = true;
        if (submitText) submitText.textContent = 'چاوەڕوان بە...';
    }

    const form = document.getElementById('portal-job-form');
    const formData = new FormData(form);
    const data = Object.fromEntries(formData.entries());

    // Fix category if other
    if (data.category === 'other' && data.category_custom) {
        data.category = data.category_custom;
    }

    const url = editId ? `/portal/jobs/${editId}` : '{{ route('portal.jobs.store') }}';
    const method = editId ? 'PUT' : 'POST';

    try {
        const res = await fetch(url, {
            method: method,
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': '{{ csrf_token() }}',
                'Accept': 'application/json',
            },
            body: JSON.stringify(data),
        });
        const json = await res.json();
        if (json.success && json.job) {
            showToast(editId ? 'هەلی کارەکە نوێکرایەوە' : 'هەلی کارەکە بە سەرکەوتوویی بڵاوکرایەوە', 'success');
            localStorage.setItem('db_active_tab', 'jobs');
            setTimeout(() => window.location.reload(), 900);
        } else {
            showToast(json.message || 'هەڵەیەک ڕوویدا لە تۆمارکردنی هەلی کارەکە', 'error');
        }
    } catch (err) {
        showToast('کێشەیەک لە پەیوەندی لەگەڵ سێرڤەر هەیە', 'error');
    } finally {
        if (btn) {
            btn.disabled = false;
            if (submitText) submitText.textContent = origText;
        }
    }
}

async function togglePortalJobActive(id) {
    const btn = document.getElementById('btn-toggle-active-' + id);
    if (btn) btn.disabled = true;

    try {
        const res = await fetch(`/portal/jobs/${id}/toggle`, {
            method: 'PATCH',
            headers: {
                'X-CSRF-TOKEN': '{{ csrf_token() }}',
                'Accept': 'application/json',
            },
        });
        const json = await res.json();
        if (json.success) {
            const chip = document.getElementById('job-status-chip-' + id);
            const statusText = document.getElementById('job-status-text-' + id);
            const activeStat = document.getElementById('stat-jobs-active');

            if (json.is_active) {
                if (chip) { chip.className = 'chip chip-ok'; }
                if (statusText) statusText.textContent = 'چالاک';
                if (btn) btn.textContent = '⏸️ ڕاگرتن';
                if (activeStat) activeStat.textContent = parseInt(activeStat.textContent || '0') + 1;
                showToast('هەلی کارەکە کارا کرا', 'success');
            } else {
                if (chip) { chip.className = 'chip chip-pending'; }
                if (statusText) statusText.textContent = 'ناچالاک';
                if (btn) btn.textContent = '▶️ کاراکردن';
                if (activeStat) activeStat.textContent = Math.max(0, parseInt(activeStat.textContent || '1') - 1);
                showToast('هەلی کارەکە بە کاتی ڕاگیرا', 'success');
            }
        } else {
            showToast('هەڵەیەک ڕوویدا لە گۆڕینی دۆخ', 'error');
        }
    } catch (err) {
        showToast('کێشەیەک لە پەیوەندی هەیە', 'error');
    } finally {
        if (btn) btn.disabled = false;
    }
}

async function deletePortalJob(id) {
    if (!confirm('دڵنیایت لە سڕینەوەی یەکجارەکی ئەم هەلی کارە؟')) return;
    try {
        const res = await fetch(`/portal/jobs/${id}`, {
            method: 'DELETE',
            headers: {
                'X-CSRF-TOKEN': '{{ csrf_token() }}',
                'Accept': 'application/json',
            },
        });
        const json = await res.json();
        if (json.success) {
            const row = document.getElementById('job-row-' + id);
            if (row) {
                row.style.transition = 'all .3s ease';
                row.style.opacity = '0';
                row.style.transform = 'translateY(10px)';
                setTimeout(() => {
                    row.remove();
                    const list = document.getElementById('portal-jobs-list');
                    if (list && list.querySelectorAll('.job-portal-card').length === 0) {
                        list.innerHTML = `
                            <div id="portal-jobs-empty" style="text-align:center; padding:3.5rem 1rem; color:var(--txt2);">
                              <div style="font-size:3.5rem; margin-bottom:.75rem; opacity: 0.6;">💼</div>
                              <div style="font-weight:800; font-size:1.1rem; color: var(--txt);">تا ئێستا هیچ هەلی کارێکت بڵاونەکردووەتەوە</div>
                              <p style="font-size:.88rem; margin-top:.4rem; color:var(--txt3);">لەرێگەی فۆڕمەکەی سەرەوە دەتوانیت پێداویستی مامۆستا و کارمەند بۆ دامەزراوەکەت ڕابگەیەنیت.</p>
                            </div>
                        `;
                    }
                }, 300);
            }
            const countEl = document.getElementById('portal-jobs-count');
            if (countEl) countEl.textContent = Math.max(0, parseInt(countEl.textContent || '1') - 1);
            const totalStat = document.getElementById('stat-jobs-total');
            if (totalStat) totalStat.textContent = Math.max(0, parseInt(totalStat.textContent || '1') - 1);
            showToast('هەلی کارەکە بە سەرکەوتوویی سڕایەوە', 'success');
        } else {
            showToast('هەڵە لە سڕینەوەی هەلی کار', 'error');
        }
    } catch (err) {
        showToast('کێشەیەک لە پەیوەندی هەیە', 'error');
    }
}
</script>
@endsection
