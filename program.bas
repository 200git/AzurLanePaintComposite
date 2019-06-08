Attribute VB_Name = "program"
Option Explicit

Public Sub Main()
  Dim GDIp As New CGDIp
  If GDIp.Startup Then
    '// ��������в���
    Dim sImg As String, sOBj As String, lCommand() As String
    lCommand = Split(Command, " ")
    sImg = lCommand(0)
    sOBj = lCommand(1)
    '// ���Դ���
    'sImg = "F:\����������ȡ\02.��ȡ\Painting\Sprite\aisaikesi.png"
    'sOBj = "F:\����������ȡ\02.��ȡ\Painting\Mesh\aisaikesi-mesh.obj"
    Dim OBj As New CObjFile
    '// ����OBj�ļ�
    If OBj.Load(sOBj) Then
      '// ����ͼƬ����ô�С
      Dim Img As Object, sW As Long, sH As Long
      Set Img = GDIp.LoadImage(sImg)
      With Img
        '// �������ÿ��,������2�Ĵη�
        '��û���뵽���õ�����ȡ���취�������ǲ�ҪЦ����
        Dim TempSize As Long
        TempSize = Fix(Log(.Width) / Log(2))
        If Log(.Width) / Log(2) > TempSize Then
          TempSize = TempSize + 1
        End If
        sW = 2 ^ TempSize
        sH = .Height
      End With
      '// ��������
      Dim Graphics As Object
      Set Graphics = GDIp.CreatGraphics(Abs(OBj.Width), OBj.Height)
      '// ��ͼ����
      Dim SrcX As Double, SrcY As Double, SrcW As Double, SrcH As Double
      Dim DstX As Long, DstY As Long, DstW As Long, DstH As Long
      Dim I As Integer: For I = 1 To OBj.FaceCout Step 2
        SrcX = OBj.Vt(OBj.Face(I).Dot(2).Vt, 0) * sW
        SrcY = Img.Height - (OBj.Vt(OBj.Face(I).Dot(2).Vt, 1) * sH)
        SrcW = (OBj.Vt(OBj.Face(I).Dot(1).Vt, 0) * sW) - SrcX
        SrcH = (OBj.Vt(OBj.Face(I).Dot(2).Vt, 1) - OBj.Vt(OBj.Face(I).Dot(3).Vt, 1)) * sH
        
        DstX = Abs(OBj.V(OBj.Face(I).Dot(2).V, 0))
        DstY = Abs(OBj.Height) - OBj.V(OBj.Face(I).Dot(2).V, 1)
        DstW = Abs(OBj.V(OBj.Face(I).Dot(1).V, 0)) - DstX
        DstH = OBj.V(OBj.Face(I).Dot(2).V, 1) - OBj.V(OBj.Face(I).Dot(3).V, 1)
        
        Graphics.DrawImage Img, SrcX, SrcY, SrcW, SrcH, DstX, DstY, DstW, DstH
      Next
      '// ����ͼƬ
      Dim l_Path As String: l_Path = App.Path
      If Right(l_Path, 1) <> "\" Then l_Path = l_Path & "\"
      l_Path = l_Path & "Picture\"
      If Len(Dir(l_Path, vbDirectory)) = 0 Then Call MkDir(l_Path)
      GDIp.Save Graphics, l_Path & Right(sImg, Len(sImg) - InStrRev(sImg, "\"))
      '// ɨβ����
      Img.Dispose
      Graphics.Dispose
      Set OBj = Nothing
    End If
    Call GDIp.Terminate
  End If
End Sub
