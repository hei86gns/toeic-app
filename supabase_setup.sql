-- ゆりあTOEIC: クラウド保存用テーブル
-- 実行先: Supabase プロジェクトA（個人用） disfgytjjflnlowywess → SQL Editor
-- 何度実行しても壊れないように書いてある。
--
-- 1ユーザー1行。アプリのデータ(DATA)をまるごと data 列にJSONで入れる。
-- 他アプリ(tangocho・筋トレ等)の user_data テーブルとは別なので、データは混ざらない。

create table if not exists public.toeic_data (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);

-- 行レベルセキュリティ: ログインした本人の行だけ読み書きできる
alter table public.toeic_data enable row level security;

drop policy if exists "toeic_data_select_own" on public.toeic_data;
create policy "toeic_data_select_own" on public.toeic_data
  for select to authenticated using ((select auth.uid()) = user_id);

drop policy if exists "toeic_data_insert_own" on public.toeic_data;
create policy "toeic_data_insert_own" on public.toeic_data
  for insert to authenticated with check ((select auth.uid()) = user_id);

drop policy if exists "toeic_data_update_own" on public.toeic_data;
create policy "toeic_data_update_own" on public.toeic_data
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

grant select, insert, update on public.toeic_data to authenticated;
