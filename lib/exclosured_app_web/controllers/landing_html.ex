defmodule ExclosuredAppWeb.LandingHTML do
  use Phoenix.Component

  embed_templates "landing_html/*"

  def oneliner_code do
    # Elixir parts: rose=keyword, emerald=atom, sky=option, amber=type
    # Rust parts: just "a + b" which is plain identifiers + operator
    ~s(<span class="text-rose-400">defwasm</span> <span class="text-emerald-400">:add</span><span class="text-slate-300">,</span> <span class="text-sky-400">args:</span> <span class="text-slate-300">[</span><span class="text-sky-400">a:</span> <span class="text-amber-400">:i32</span><span class="text-slate-300">,</span> <span class="text-sky-400">b:</span> <span class="text-amber-400">:i32</span><span class="text-slate-300">],</span> <span class="text-sky-400">do:</span> <span class="text-emerald-400">~RUST"</span><span class="text-slate-100">a </span><span class="text-rose-400">+</span><span class="text-slate-100"> b</span><span class="text-emerald-400">"</span>)
  end

  def multiline_code do
    # Rust syntax highlighting colors:
    # rose-400: keywords (let, mut, for, in, return)
    # amber-400: types (i32, u32)
    # sky-400: numeric literals (0, 1)
    # slate-100: identifiers (a, b, n, temp)
    # rose-400: operators (+, ..)
    # slate-400: punctuation ({, }, ;)
    """
    <span class="text-rose-400">defwasm</span> <span class="text-emerald-400">:fibonacci</span><span class="text-slate-300">,</span>
      <span class="text-sky-400">args:</span> <span class="text-slate-300">[</span><span class="text-sky-400">n:</span> <span class="text-amber-400">:i32</span><span class="text-slate-300">],</span>
      <span class="text-sky-400">do:</span> <span class="text-emerald-400">~RUST&quot;&quot;&quot;</span>
      <span class="text-rose-400">let mut</span> <span class="text-slate-100">a</span><span class="text-slate-400">:</span> <span class="text-amber-400">i32</span> <span class="text-slate-400">=</span> <span class="text-sky-400">0</span><span class="text-slate-400">;</span>
      <span class="text-rose-400">let mut</span> <span class="text-slate-100">b</span><span class="text-slate-400">:</span> <span class="text-amber-400">i32</span> <span class="text-slate-400">=</span> <span class="text-sky-400">1</span><span class="text-slate-400">;</span>
      <span class="text-rose-400">for</span> <span class="text-slate-100">_</span> <span class="text-rose-400">in</span> <span class="text-sky-400">0</span><span class="text-rose-400">..</span><span class="text-slate-100">n</span> <span class="text-slate-400">{</span>
          <span class="text-rose-400">let</span> <span class="text-slate-100">temp</span> <span class="text-slate-400">=</span> <span class="text-slate-100">b</span><span class="text-slate-400">;</span>
          <span class="text-slate-100">b</span> <span class="text-slate-400">=</span> <span class="text-slate-100">a</span> <span class="text-rose-400">+</span> <span class="text-slate-100">b</span><span class="text-slate-400">;</span>
          <span class="text-slate-100">a</span> <span class="text-slate-400">=</span> <span class="text-slate-100">temp</span><span class="text-slate-400">;</span>
      <span class="text-slate-400">}</span>
      <span class="text-slate-100">a</span>
      <span class="text-emerald-400">&quot;&quot;&quot;</span>\
    """
  end
end
