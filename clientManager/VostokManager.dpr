program VostokManager;

uses
  Forms,
  Password in 'Password.pas' {fr_regestrat},
  DM in 'DM.pas' {DataModuls: TDataModule},
  Main_manager in 'Main_manager.pas' {fr_main_manager},
  find_gost in 'find_gost.pas' {fr_find_gost},
  find_schet in 'find_schet.pas' {fr_duble_schet},
  nom_sost in 'nom_sost.pas' {fr_sost_nom},
  prn_kalkulat in 'prn_kalkulat.pas' {fr_prn_kalc_noms},
  progress_window in 'progress_window.pas' {fr_progress},
  Talon_dlg in 'Talon_dlg.pas' {fr_prn_tal_dlg},
  Ask_chislo in '..\clientADM\Ask_chislo.pas' {fr_get_chislo},
  Othc_nach_rasm in 'Othc_nach_rasm.pas' {fr_otchets_nach_rasm},
  prn_otch_sch in 'prn_otch_sch.pas' {fr_prm_schet_otchet},
  prn_otch_ord in 'prn_otch_ord.pas' {fr_prn_vozvr_otch},
  Post in 'Post.pas' {fr_post_list},
  Read_text_post in 'Read_text_post.pas' {fr_text_message},
  Post_out in 'Post_out.pas' {fr_post_list_out},
  New_message in 'New_message.pas' {fr_New_mes},
  List_gost in 'List_gost.pas' {fr_gost_period},
  prn_gost_lst in 'prn_gost_lst.pas' {fr_prn_gost_lst},
  Rsch_bron in 'Rsch_bron.pas' {fr_bn_rsch},
  Kvo_gosts in 'Kvo_gosts.pas' {fr_count_gost},
  prn_ingosts in 'prn_ingosts.pas' {fr_ingost_prn},
  Zn_nom_prc in 'Zn_nom_prc.pas' {fr_proc_zn},
  prn_talons in 'prn_talons.pas' {fr_prn_talons},
  prn_gen_ubor in 'prn_gen_ubor.pas' {fr_prn_gen_ubork},
  gen_ubor in 'gen_ubor.pas' {fr_genubor_dlg},
  prn_group_sch in 'prn_group_sch.pas' {fr_prn_grup_sch},
  List_grup in 'List_grup.pas' {fr_group_list},
  Last_general in 'Last_general.pas' {fr_last_general},
  filtr_gost in 'filtr_gost.pas' {fr_filtr_gost},
  List_gost_fltr in 'List_gost_fltr.pas' {prn_gost_list_fltr},
  prn_sng_gosts in 'prn_sng_gosts.pas' {fr_sng_gost_prn};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'АРМ Менеджер гостиницы';
  Application.CreateForm(Tfr_main_manager, fr_main_manager);
  Application.CreateForm(Tfr_filtr_gost, fr_filtr_gost);
  Application.Run;
end.
