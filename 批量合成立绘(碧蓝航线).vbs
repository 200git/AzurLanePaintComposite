'// Title �����ϳ�����(��������)
'// Time  20190607

'// ǿ��ʹ��cscript.exe
Dim Wshell
SET Wshell=CreateObject("Wscript.Shell")
If lcase(right(Wscript.fullName,11)) = "wscript.exe" then 
 Wshell.run "cmd /k cscript.exe //nologo " & chr(34) & wscript.scriptfullname & chr(34)
 WScript.Quit
End If
Set Wshell = Nothing

'// ѡ��Ŀ¼�Ի���
Public Function SelectFolder(ByVal sText)
  On Error Resume Next
  Dim dirPath : dirPath = CreateObject("Shell.Application") _
    .BrowseForFolder(0, sText, &H0211, "").items().item().path 
  If right(dirPath,1)<>"\" then 
    dirPath=dirpath&"\" 
  End if
  If dirpath="\" then
    dirpath="DOCUME~1\Admini~1\����\"
  End If
  SelectFolder = dirPath
End Function

'// ���Ŀ¼
Dim Fso:Set Fso = CreateObject("Scripting.FileSystemObject")
Dim Ws:Set Ws = CreateObject("WScript.Shell") 
'Dim Path:Path = SelectFolder("ѡ���������������Ŀ¼(����Mesh��Texture2D�ļ���)")
Dim Path:Path = "F:\����������ȡ\02.��ȡ\Painting\"
Dim Mesh_Path : Mesh_Path = Path & "Mesh\"
Dim Img_Path : Img_Path = Path & "Texture2D\"
Dim App_Path : App_Path = Fso.GetFile(Wscript.ScriptFullName).ParentFolder.Path
If Right(App_Path,1) <> "\" Then  App_Path = App_Path & "\" 

'// �ϳ�ͼƬ
With Fso
  If .FolderExists(Mesh_Path) Then
    Dim length ,Mark ,Temp,Count
    Dim File : For Each File in .GetFolder(Mesh_Path).Files
      l = Len(File) : Mark = InStrRev(File,"-")
      If LCase(Right(File,l - Mark)) = "mesh.obj" Then
        Temp = InStrRev(File,"\")
        Temp = Mid(File,Temp + 1,l - Temp - 9)
        Temp = Img_Path & Temp & ".png"
        If .FileExists(Temp) Then
          Count = Count + 1
          Ws.Run App_Path & "AzurLanePaintComposite.exe " _
            & Temp & " " & File, 0,True
          WScript.Echo "�ϳ�["&Count&"] " & Temp
        End If
      End If
    Next
  End If
End With
WScript.Echo "------ ���ƺϳ�" & Count & "������ ------"