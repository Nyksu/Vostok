program ClientADM;

uses
  Forms,
  MainADM in 'MainADM.pas' {fr_ClientAdm},
  autitarif in 'autitarif.pas' {fr_auto_tarif},
  ed_arif in 'ed_arif.pas' {fr_edit_tarif},
  simpl_polelen in 'simpl_polelen.pas' {fr_simpl_polelen},
  change_nomer in 'change_nomer.pas' {fr_change_nomer},
  prn_nal_schet in 'prn_nal_schet.pas' {fr_prn_nal_schet},
  prn_talons in 'prn_talons.pas' {fr_prn_talons},
  vozvr_nal in 'vozvr_nal.pas' {fr_vozvr_nal_singl},
  Ask_dlg in 'Ask_dlg.pas' {fr_dialog},
  prodl_nal in 'prodl_nal.pas' {fr_prodlenie},
  Move_gost in 'Move_gost.pas' {fr_move_gost},
  go_out in 'go_out.pas' {fr_go_out},
  prn_rash_order in 'prn_rash_order.pas' {fr_rashod_order},
  prn_otch_sch in 'prn_otch_sch.pas' {fr_prm_schet_otchet},
  prn_otch_ord in 'prn_otch_ord.pas' {fr_prn_vozvr_otch},
  prn_otch_sch_del in 'prn_otch_sch_del.pas' {fr_prn_otch_del_sch},
  bn_poselen in 'bn_poselen.pas' {fr_posel_bn},
  Move_gost_bn in 'Move_gost_bn.pas' {fr_move_bn_gost},
  prodl_bznal in 'prodl_bznal.pas' {fr_prodl_bn},
  prodl_bn_lst in 'prodl_bn_lst.pas' {fr_prod_bn_lst},
  find_gost in 'find_gost.pas' {fr_find_gost},
  nom_sost in 'nom_sost.pas' {fr_sost_nom},
  progress_window in '..\clientManager\progress_window.pas' {fr_progress},
  Corrector in 'Corrector.pas' {fr_correct},
  other_men in 'other_men.pas' {fr_add_dr_gost},
  Test_black in 'Test_black.pas' {fr_black_test},
  Calc_besnal in 'Calc_besnal.pas' {fr_calk_besnal},
  Post in 'Post.pas' {fr_post_list},
  Post_out in 'Post_out.pas' {fr_post_list_out},
  New_message in 'New_message.pas' {fr_New_mes},
  Read_text_post in 'Read_text_post.pas' {fr_text_message},
  reg_sng in 'reg_sng.pas' {fr_sng_reg},
  reg_burguys in 'reg_burguys.pas' {fr_in_men},
  ClientADM_TLB in 'ClientADM_TLB.pas',
  group_schet in 'group_schet.pas' {fr_grup_schet},
  prn_group_sch in 'prn_group_sch.pas' {fr_prn_grup_sch},
  Kvo_gosts in 'Kvo_gosts.pas' {fr_count_gost},
  prn_ingosts in 'prn_ingosts.pas' {fr_ingost_prn},
  prn_sng_gosts in 'prn_sng_gosts.pas' {fr_sng_gost_prn},
  GetDataDlg in 'GetDataDlg.pas' {fr_get_date},
  dubSch in 'dubSch.pas' {duble_schet},
  print_bn_calc in 'print_bn_calc.pas' {fr_prn_calc_bn},
  List_grup in 'List_grup.pas' {fr_group_list};

{$R *.TLB}

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'АРМ Регистрация и расчеты, V 1.1';
  Application.CreateForm(Tfr_ClientAdm, fr_ClientAdm);
  Application.Run;
end.
